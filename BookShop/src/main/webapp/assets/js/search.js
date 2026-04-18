/**
 * 
 */
// File: assets/js/search.js
document.addEventListener('DOMContentLoaded', function() {
    var searchInput = document.getElementById('live-search-input');
    var resultsWrapper = document.getElementById('live-search-results');
    var itemsList = document.getElementById('search-items-list');
    var viewAllBtn = document.getElementById('search-view-all');
    
    // Lấy contextPath từ thuộc tính data của thẻ body hoặc input (sẽ cấu hình ở Bước 2)
    var ctx = document.body.getAttribute('data-context-path'); 

    if (!searchInput) return;

    searchInput.addEventListener('input', function() {
        var keyword = this.value.trim();
        if (keyword.length < 2) {
            resultsWrapper.style.display = 'none';
            return;
        }

        fetch(ctx + '/api/search-suggest?keyword=' + encodeURIComponent(keyword))
            .then(res => res.json())
            .then(data => {
                if (data && data.length > 0) {
                    var html = '';
                    data.forEach(book => {
                        var imgPath = book.image ? book.image : (ctx + '/assets/images/books/default-book.png');
                        html += '<a href="' + ctx + '/books/detail?id=' + book.id + '" class="search-result-item">' +
                                '<img src="' + imgPath + '">' +
                                '<div class="result-info">' +
                                '<span class="title">' + book.title + '</span>' +
                                '<span class="price">' + Number(book.price).toLocaleString('vi-VN') + ' đ</span>' +
                                '</div></a>';
                    });
                    itemsList.innerHTML = html;
                    viewAllBtn.setAttribute('href', ctx + '/books?keyword=' + encodeURIComponent(keyword));
                    viewAllBtn.style.display = 'block';
                    resultsWrapper.style.display = 'block';
                } else {
                    itemsList.innerHTML = '<div style="padding:15px; font-size:13px;">Không tìm thấy kết quả.</div>';
                    viewAllBtn.style.display = 'none';
                    resultsWrapper.style.display = 'block';
                }
            })
            .catch(err => console.error('Search Error:', err));
    });

    document.addEventListener('click', function(e) {
        if (resultsWrapper && !resultsWrapper.contains(e.target) && e.target !== searchInput) {
            resultsWrapper.style.display = 'none';
        }
    });
});