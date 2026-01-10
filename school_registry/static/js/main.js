// Основной JavaScript файл

// Инициализация при загрузке страницы
document.addEventListener('DOMContentLoaded', function() {
    // Инициализация всех компонентов
    initComponents();
    
    // Обработка форм
    initForms();
    
    // Динамическая загрузка данных
    initDynamicLoading();
});

// Инициализация компонентов
function initComponents() {
    // Всплывающие подсказки
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Всплывающие окна
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });
    
    // Подтверждение действий
    var confirmActions = document.querySelectorAll('.confirm-action');
    confirmActions.forEach(function(element) {
        element.addEventListener('click', function(e) {
            if (!confirm('Вы уверены?')) {
                e.preventDefault();
                return false;
            }
        });
    });
}

// Обработка форм
function initForms() {
    // Динамическое обновление населенных пунктов при выборе района
    var districtSelect = document.getElementById('district-select');
    if (districtSelect) {
        districtSelect.addEventListener('change', function() {
            var districtId = this.value;
            var settlementSelect = document.getElementById('settlement-select');
            
            if (districtId) {
                fetch(`/api/districts/${districtId}/settlements`)
                    .then(response => response.json())
                    .then(data => {
                        settlementSelect.innerHTML = '<option value="">Выберите населенный пункт</option>';
                        data.forEach(function(settlement) {
                            var option = document.createElement('option');
                            option.value = settlement.id;
                            option.textContent = settlement.type + ' ' + settlement.name;
                            settlementSelect.appendChild(option);
                        });
                    })
                    .catch(error => {
                        console.error('Ошибка при загрузке населенных пунктов:', error);
                    });
            }
        });
    }
    
    // Валидация форм
    var forms = document.querySelectorAll('.needs-validation');
    forms.forEach(function(form) {
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        });
    });
    
    // Подсчет символов в текстовых полях
    var textAreas = document.querySelectorAll('textarea[data-max-length]');
    textAreas.forEach(function(textarea) {
        var maxLength = textarea.getAttribute('data-max-length');
        var counter = document.createElement('div');
        counter.className = 'form-text text-end small';
        counter.innerHTML = `<span class="char-count">0</span> / ${maxLength}`;
        
        textarea.parentNode.appendChild(counter);
        
        textarea.addEventListener('input', function() {
            var length = this.value.length;
            var charCount = this.parentNode.querySelector('.char-count');
            charCount.textContent = length;
            
            if (length > maxLength) {
                charCount.classList.add('text-danger');
            } else {
                charCount.classList.remove('text-danger');
            }
        });
    });
}

// Динамическая загрузка данных
function initDynamicLoading() {
    // Ленивая загрузка изображений
    var lazyImages = document.querySelectorAll('img[data-src]');
    
    if ('IntersectionObserver' in window) {
        var imageObserver = new IntersectionObserver(function(entries, observer) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    var img = entry.target;
                    img.src = img.getAttribute('data-src');
                    img.removeAttribute('data-src');
                    imageObserver.unobserve(img);
                }
            });
        });
        
        lazyImages.forEach(function(img) {
            imageObserver.observe(img);
        });
    } else {
        // Fallback для старых браузеров
        lazyImages.forEach(function(img) {
            img.src = img.getAttribute('data-src');
        });
    }
    
    // Бесконечная прокрутка (если есть)
    var infiniteScrollContainer = document.querySelector('.infinite-scroll');
    if (infiniteScrollContainer) {
        window.addEventListener('scroll', function() {
            if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 500) {
                loadMoreContent();
            }
        });
    }
}

// Загрузка дополнительного контента
function loadMoreContent() {
    var nextPage = document.querySelector('.pagination .active').nextElementSibling;
    if (!nextPage || nextPage.classList.contains('disabled')) {
        return;
    }
    
    var url = nextPage.querySelector('a').href;
    var loadingIndicator = document.getElementById('loading-indicator');
    
    if (loadingIndicator) {
        loadingIndicator.style.display = 'block';
    }
    
    fetch(url)
        .then(response => response.text())
        .then(html => {
            var parser = new DOMParser();
            var doc = parser.parseFromString(html, 'text/html');
            var newItems = doc.querySelector('.schools-container').innerHTML;
            
            document.querySelector('.schools-container').innerHTML += newItems;
            
            if (loadingIndicator) {
                loadingIndicator.style.display = 'none';
            }
            
            // Обновляем URL без перезагрузки страницы
            window.history.pushState({}, '', url);
            
            // Повторно инициализируем компоненты для новых элементов
            initComponents();
        })
        .catch(error => {
            console.error('Ошибка при загрузке контента:', error);
            if (loadingIndicator) {
                loadingIndicator.style.display = 'none';
            }
        });
}

// Вспомогательные функции
function showToast(message, type = 'info') {
    var toastContainer = document.getElementById('toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toast-container';
        toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
        document.body.appendChild(toastContainer);
    }
    
    var toastId = 'toast-' + Date.now();
    var toastHtml = `
        <div id="${toastId}" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header bg-${type} text-white">
                <strong class="me-auto">Уведомление</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
            </div>
            <div class="toast-body">
                ${message}
            </div>
        </div>
    `;
    
    toastContainer.insertAdjacentHTML('beforeend', toastHtml);
    
    var toastElement = document.getElementById(toastId);
    var toast = new bootstrap.Toast(toastElement);
    toast.show();
    
    // Удаляем toast после скрытия
    toastElement.addEventListener('hidden.bs.toast', function () {
        toastElement.remove();
    });
}

// AJAX запросы с обработкой ошибок
function ajaxRequest(url, options = {}) {
    const defaults = {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        }
    };
    
    const config = { ...defaults, ...options };
    
    return fetch(url, config)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .catch(error => {
            console.error('AJAX request failed:', error);
            showToast('Произошла ошибка при загрузке данных', 'danger');
            throw error;
        });
}

// Форматирование чисел
function formatNumber(number) {
    return new Intl.NumberFormat('ru-RU').format(number);
}

// Форматирование даты
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('ru-RU', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
}

// Копирование в буфер обмена
function copyToClipboard(text) {
    navigator.clipboard.writeText(text)
        .then(() => {
            showToast('Скопировано в буфер обмена', 'success');
        })
        .catch(err => {
            console.error('Ошибка при копировании:', err);
            showToast('Ошибка при копировании', 'danger');
        });
}

// Экспорт модулей (если используется модульная система)
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        initComponents,
        initForms,
        initDynamicLoading,
        showToast,
        ajaxRequest,
        formatNumber,
        formatDate,
        copyToClipboard
    };
}