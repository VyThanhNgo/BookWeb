<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setLocale value="vi_VN"/>

<%@ include file="/WEB-INF/views/base/header.jsp" %>
<div class="page-content bg-grey">
<section class="content-inner-1">
			<div class="container">
				<div class="row book-grid-row style-4 m-b60">
					<div class="col">
						<div class="dz-box">
							<div class="dz-media">
								<img src="https://tse1.mm.bing.net/th/id/OIP.8625mdkok4pn8q1GhFvTwgHaIj?pid=Api&P=0&h=180" alt="book">
							</div>
							<div class="dz-content">
								<div class="dz-header">
									<h3 class="title">${book.title}</h3>
									<div class="shop-item-rating">
										<div class="d-lg-flex d-sm-inline-flex d-flex align-items-center">
											<ul class="dz-rating">
												<li><i class="flaticon-star text-yellow"></i></li>	
												<li><i class="flaticon-star text-yellow"></i></li>	
												<li><i class="flaticon-star text-yellow"></i></li>	
												<li><i class="flaticon-star text-yellow"></i></li>		
												<li><i class="flaticon-star text-muted"></i></li>		
											</ul>
											<h6 class="m-b0">4.0</h6>
										</div>
										<div class="social-area">
											<ul class="dz-social-icon style-3">
												<li><a href="https://www.facebook.com/dexignzone" target="_blank"><i class="fa-brands fa-facebook-f"></i></a></li>
												<li><a href="https://twitter.com/dexignzones" target="_blank"><i class="fa-brands fa-twitter"></i></a></li>
												<li><a href="https://www.whatsapp.com/" target="_blank"><i class="fa-brands fa-whatsapp"></i></a></li>
												<li><a href="https://www.google.com/intl/en-GB/gmail/about/" target="_blank"><i class="fa-solid fa-envelope"></i></a></li>
											</ul>
										</div>
									</div>
								</div>
								<div class="dz-body">
									<div class="book-detail">
										<ul class="book-info">
											<li>
												<div class="writer-info">
													<img src="images/profile2.jpg" alt="book">
													<div>
														<span>Writen by</span>${book.author.name}
													</div>
												</div>
											</li>
											<li><span>Publisher</span>Printarea Studios</li>
											<li><span>Year</span>${book.publishYear}</li>
										</ul>
									</div>
									<p class="text-1">${book.description}</p>
									<p class="text-2">Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem</p>
									<div class="book-footer">
										<div class="price">
											<h5><fmt:formatNumber value="${book.price}" pattern="#,###"/>&#8363;</h5>
											<p class="p-lr10">$70.00</p>
										</div>
										<form action="${ctx}/cart" method="post" class="product-num">
											<input type="hidden" name="action" value="add">
											<input type="hidden" name="id" value="${book.id}">

											<div class="quantity btn-quantity style-1 me-3">
												<div class="input-group bootstrap-touchspin">
													<span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
													<input id="demo_vertical2" type="text" value="1" name="quantity" class="form-control" style="display: block;">
													<span class="input-group-addon bootstrap-touchspin-postfix" style="display: none;"></span>
													<span class="input-group-btn-vertical">
                <button class="btn btn-default bootstrap-touchspin-up" type="button"><i class="ti-plus"></i></button>
                <button class="btn btn-default bootstrap-touchspin-down" type="button"><i class="ti-minus"></i></button>
            </span>
												</div>
											</div>

											<button type="submit" class="btn btn-primary btnhover btnhover2">
												<i class="flaticon-shopping-cart-1"></i>
												<span>Add to cart</span>
											</button>

											<div class="bookmark-btn style-1 d-none d-sm-block">
												<input class="form-check-input" type="checkbox" id="flexCheckDefault1">
												<label class="form-check-label" for="flexCheckDefault1">
													<i class="flaticon-heart"></i>
												</label>
											</div>
										</form>									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xl-8">
						<div class="product-description tabs-site-button">
                            <ul class="nav nav-tabs">
                                <li><a data-bs-toggle="tab" href="#graphic-design-1" class="">Details Product</a></li>
                                <li><a data-bs-toggle="tab" href="#developement-1">Customer Reviews</a></li>
                            </ul>
							<div class="tab-content">
								<div id="graphic-design-1" class="tab-pane show active">
                                    <table class="table border book-overview">
                                        <tbody><tr>
                                            <th>Book Title</th>
                                            <td>${book.title}</td>
                                        </tr>
                                        <tr>
                                            <th>Author</th>
                                            <td>${book.author.name}</td>
                                        </tr>
                                        <tr>
                                            <th>ISBN</th>
                                            <td>121341381648 (ISBN13: 121341381648)</td>
                                        </tr>
										<tr>
                                            <th>Ediiton Language</th>
                                            <td>English</td>
                                        </tr>
                                        <tr>
                                            <th>Book Format</th>
                                            <td>Paperback, 450 Pages</td>
                                        </tr>
                                        <tr>
                                            <th>Date Published</th>
                                            <td>August 10th 2019</td>
                                        </tr>
										<tr>
                                            <th>Publisher</th>
                                            <td>Wepress Inc.</td>
                                        </tr>
										<tr>
                                            <th>Pages</th>
                                            <td>520</td>
                                        </tr>
										<tr>
                                            <th>Lesson</th>
                                            <td>7</td>
                                        </tr>
										<tr>
                                            <th>Topic</th>
                                            <td>360</td>
                                        </tr>
                                        <tr class="tags">
                                            <th>Tags</th>
                                            <td>
												<a href="javascript:void(0);" class="badge">Drama</a>
												<a href="javascript:void(0);" class="badge">Advanture</a>
												<a href="javascript:void(0);" class="badge">Survival</a>
												<a href="javascript:void(0);" class="badge">Biography</a>
												<a href="javascript:void(0);" class="badge">Trending2024</a>
												<a href="javascript:void(0);" class="badge">Bestseller</a>
											</td>
                                        </tr>
                                    </tbody></table>
                                </div>
								<div id="developement-1" class="tab-pane">
                                    <div class="clear" id="comment-list">
										<div class="post-comments comments-area style-1 clearfix">
											<h4 class="comments-title">4 COMMENTS</h4>
											<div id="comment">
												<ol class="comment-list">
													<li class="comment even thread-even depth-1 comment" id="comment-2">
														<div class="comment-body">
														  <div class="comment-author vcard">
																<img src="images/profile4.jpg" alt="" class="avatar">
																<cite class="fn">Michel Poe</cite> <span class="says">says:</span>
																<div class="comment-meta">
																	<a href="javascript:void(0);">December 22, 2024 at 6:14 am</a>
																</div>
														  </div>
													  <div class="comment-content dlab-page-text">
														 <p>Donec suscipit porta lorem eget condimentum. Morbi vitae mauris in leo venenatis varius. Aliquam nunc enim, egestas ac dui in, aliquam vulputate erat.</p>
													  </div>
													  <div class="reply">
														 <a rel="nofollow" class="comment-reply-link" href="javascript:void(0);"><i class="fa fa-reply"></i> Reply</a>
													  </div>
												   </div>
												   <ol class="children">
													  <li class="comment byuser comment-author-w3itexpertsuser bypostauthor odd alt depth-2 comment" id="comment-3">
														 <div class="comment-body" id="div-comment-3">
															<div class="comment-author vcard">
															   <img src="images/profile3.jpg" alt="" class="avatar">
															   <cite class="fn">Celesto Anderson</cite> <span class="says">says:</span>
															   <div class="comment-meta">
																  <a href="javascript:void(0);">December 22, 2024 at 6:14 am</a>
															   </div>
															</div>
															<div class="comment-content dlab-page-text">
															   <p>Donec suscipit porta lorem eget condimentum. Morbi vitae mauris in leo venenatis varius. Aliquam nunc enim, egestas ac dui in, aliquam vulputate erat.</p>
															</div>
															<div class="reply">
															   <a class="comment-reply-link" href="javascript:void(0);"><i class="fa fa-reply"></i> Reply</a>
															</div>
														 </div>
													  </li>
												   </ol>
												</li>
												<li class="comment even thread-odd thread-alt depth-1 comment" id="comment-4">
												   <div class="comment-body" id="div-comment-4">
													  <div class="comment-author vcard">
														 <img src="images/profile2.jpg" alt="" class="avatar">
														 <cite class="fn">Ryan</cite> <span class="says">says:</span>
														 <div class="comment-meta">
															<a href="javascript:void(0);">December 22, 2024 at 6:14 am</a>
														 </div>
													  </div>
													  <div class="comment-content dlab-page-text">
														 <p>Donec suscipit porta lorem eget condimentum. Morbi vitae mauris in leo venenatis varius. Aliquam nunc enim, egestas ac dui in, aliquam vulputate erat.</p>
													  </div>
													  <div class="reply">
														 <a class="comment-reply-link" href="javascript:void(0);"><i class="fa fa-reply"></i> Reply</a>
													  </div>
												   </div>
												</li>
												<li class="comment odd alt thread-even depth-1 comment" id="comment-5">
												   <div class="comment-body" id="div-comment-5">
													  <div class="comment-author vcard">
														 <img src="images/profile1.jpg" alt="" class="avatar">
														 <cite class="fn">Stuart</cite> <span class="says">says:</span>
														 <div class="comment-meta">
															<a href="javascript:void(0);">December 22, 2024 at 6:14 am</a>
														 </div>
													  </div>
													  <div class="comment-content dlab-page-text">
														 <p>Donec suscipit porta lorem eget condimentum. Morbi vitae mauris in leo venenatis varius. Aliquam nunc enim, egestas ac dui in, aliquam vulputate erat.</p>
													  </div>
													  <div class="reply">
														 <a rel="nofollow" class="comment-reply-link" href="javascript:void(0);"><i class="fa fa-reply"></i> Reply</a>
													  </div>
												   </div>
												</li>
											 </ol>
										  </div>
										  <div class="default-form comment-respond style-1" id="respond">
											 <h4 class="comment-reply-title" id="reply-title">LEAVE A REPLY <small> <a rel="nofollow" id="cancel-comment-reply-link" href="javascript:void(0)" style="display:none;">Cancel reply</a> </small></h4>
											 <div class="clearfix">
												<form method="post" id="comments_form" class="comment-form" novalidate="">
												   <p class="comment-form-author"><input id="name" placeholder="Author" name="author" type="text" value=""></p>
												   <p class="comment-form-email"><input id="email" required="required" placeholder="Email" name="email" type="email" value=""></p>
												   <p class="comment-form-comment"><textarea id="comments" placeholder="Type Comment Here" class="form-control4" name="comment" cols="45" rows="3" required="required"></textarea></p>
												   <p class="col-md-12 col-sm-12 col-xs-12 form-submit">
													  <button id="submit" type="submit" class="submit btn btn-primary filled">
													  Submit Now <i class="fa fa-angle-right m-l10"></i>
													  </button>
												   </p>
												</form>
											 </div>
										  </div>
									   </div>
									</div>
									
								</div>
							</div>
						</div>
					</div>
					<div class="col-xl-4 mt-5 mt-xl-0">
						<div class="widget">
							<h4 class="widget-title">Related Books</h4>
							<div class="row">
							<c:forEach var="rb" items="${relatedBooks}">
								<div class="col-xl-12 col-lg-6">
									<div class="dz-shop-card style-5">
										<div class="dz-media">
											<img src="https://tse1.mm.bing.net/th/id/OIP.8625mdkok4pn8q1GhFvTwgHaIj?pid=Api&P=0&h=180" alt="${rb.title}">
										</div>
										<div class="dz-content">
											<h5 class="subtitle"><a href="${pageContext.request.contextPath}/books/detail?id=${rb.id}">${rb.title}</a>
											</h5>
											<ul class="dz-tags">
												<li>${rb.category.name}</li>
												
											</ul>
											<div class="price">
												<span class="price-num"><fmt:formatNumber value="${rb.price}" pattern="#,###"/>&#8363;</span>
												<del>$98.4</del>
											</div>
											<form action="${ctx}/cart" method="post" style="display:inline-block;">
												<input type="hidden" name="action" value="add">
												<input type="hidden" name="id" value="${rb.id}">
												<input type="hidden" name="quantity" value="1">

												<button type="submit" class="btn btn-outline-primary btn-sm btnhover btnhover2">
													<i class="flaticon-shopping-cart-1 me-2"></i> Add to cart
												</button>
											</form>										</div>
									</div>
								</div>
							</c:forEach>
						
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
		
		<!-- Client Start-->
		<div class="bg-white py-5">
			<div class="container">
			<!--Client Swiper -->
				<div class="swiper client-swiper swiper-initialized swiper-horizontal swiper-backface-hidden">
					<div class="swiper-wrapper" id="swiper-wrapper-7cdaae2b34727a6a" aria-live="off" style="transition-duration: 0ms; transform: translate3d(0px, 0px, 0px); transition-delay: 0ms;">
						<div class="swiper-slide swiper-slide-active" role="group" aria-label="1 / 5" style="width: 292.5px;"><img src="images/client/client1.svg" alt="client"></div>
						<div class="swiper-slide swiper-slide-next" role="group" aria-label="2 / 5" style="width: 292.5px;"><img src="images/client/client2.svg" alt="client"></div>
						<div class="swiper-slide" role="group" aria-label="3 / 5" style="width: 292.5px;"><img src="images/client/client3.svg" alt="client"></div>
						<div class="swiper-slide" role="group" aria-label="4 / 5" style="width: 292.5px;"><img src="images/client/client4.svg" alt="client"></div>
						<div class="swiper-slide" role="group" aria-label="5 / 5" style="width: 292.5px;"><img src="images/client/client5.svg" alt="client"></div>	
					</div>
				<span class="swiper-notification" aria-live="assertive" aria-atomic="true"></span></div>
			</div>
		</div>
		<!-- Client End-->
		
		<!-- Feature Box -->
		<section class="content-inner">
			<div class="container">
				<div class="row sp15">
					<div class="col-lg-3 col-md-6 col-sm-6 col-6">
						<div class="icon-bx-wraper style-2 m-b30 text-center">
							<div class="icon-bx-lg">
								<i class="fa-solid fa-users icon-cell"></i>
							</div>
							<div class="icon-content">
								<h2 class="dz-title counter m-b0">125,663</h2>
								<p class="font-20">Happy Customers</p>
							</div>
						</div>
					</div>
					<div class=" col-lg-3 col-md-6 col-sm-6 col-6">
						<div class="icon-bx-wraper style-2 m-b30 text-center">
							<div class="icon-bx-lg"> 
								<i class="fa-solid fa-book icon-cell"></i>
							</div>
							<div class="icon-content">
								<h2 class="dz-title counter m-b0">50,672</h2>
								<p class="font-20">Book Collections</p>
							</div>
						</div>
					</div>
					<div class="col-lg-3 col-md-6 col-sm-6 col-6">
						<div class="icon-bx-wraper style-2 m-b30 text-center">
							<div class="icon-bx-lg"> 
								<i class="fa-solid fa-store icon-cell"></i>
							</div>
							<div class="icon-content">
								<h2 class="dz-title counter m-b0">1,562</h2>
								<p class="font-20">Our Stores</p>
							</div>
						</div>
					</div>
					<div class="col-lg-3 col-md-6 col-sm-6 col-6">
						<div class="icon-bx-wraper style-2 m-b30 text-center">
							<div class="icon-bx-lg"> 
								<i class="fa-solid fa-leaf icon-cell"></i>
							</div>
							<div class="icon-content">
								<h2 class="dz-title counter m-b0">457</h2>
								<p class="font-20">Famous Writers</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
		<!-- Feature Box End -->
		
		<!-- Newsletter -->
		<section class="py-5 newsletter-wrapper" style="background-image: url('images/background/bg1.jpg'); background-size: cover;">
			<div class="container">
				<div class="subscride-inner">
					<div class="row style-1 justify-content-xl-between justify-content-lg-center align-items-center text-xl-start text-center">
						<div class="col-xl-7 col-lg-12">
							<div class="section-head mb-0">
								<h2 class="title text-white my-lg-3 mt-0">Subscribe our newsletter for newest books updates</h2>
							</div>
						</div>
						<div class="col-xl-5 col-lg-6">
							<form class="dzSubscribe style-1" action="script/mailchamp.php" method="post">
								<div class="dzSubscribeMsg"></div>
								<div class="form-group">
									<div class="input-group mb-0">
										<input name="dzEmail" required="required" type="email" class="form-control bg-transparent text-white" placeholder="Your Email Address" fdprocessedid="amyxt">
										<div class="input-group-addon">
											<button name="submit" value="Submit" type="submit" class="btn btn-primary btnhover" fdprocessedid="vn8wzo">
												<span>SUBSCRIBE</span>
												<i class="fa-solid fa-paper-plane"></i>
											</button>
										</div>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</section>
		<!-- Newsletter End -->
	</div>
		<%@ include file="/WEB-INF/views/base/footer.jsp" %>