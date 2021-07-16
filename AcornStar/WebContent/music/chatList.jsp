<%@page import="test.chat.dto.ChatDto"%>
<%@page import="java.util.List"%>
<%@page import="test.chat.dao.ChatDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String id=(String)session.getAttribute("id");

	List<ChatDto> list=ChatDao.getInstance().getList();
	for(int i=0; i<list.size(); i++){
		System.out.println(list.get(i));
	}
	
%>
	<!-- chat의 list를 불러온다. -->
	<ul id="chatList" style="padding:0px;">
		<%if(list.size()>=6) {%>
			<%for(ChatDto tmp:list){ %>
				<%if(tmp.getWriter().equals(id)){ %>
					<li style="padding-left:200px;">
						<div>
							<dl>
								<dt>
									<span class="float-end me-2"><%=tmp.getWriter() %></span>
								</dt>
								<dd>
									<pre class="form-control" style="margin:0px"><%=tmp.getContent() %></pre>
								</dd>
							</dl>
						</div>
					</li>
				<%} else {%>
					<li style="padding-right:200px;">
						<div>
							<dl>
								<dt>
									<span class="float-start ms-2"><%=tmp.getWriter() %></span>
								</dt>
								<dd>
									<pre class="form-control" style="margin:0px"><%=tmp.getContent() %></pre>
								</dd>
							</dl>
						</div>
					</li>
				<%} %>
			<%} %>
		<%} else if(list.size()<6){ 
			for(int i=0; i<10-list.size(); i++){%>
				<li>
					<div>
						<dl>
							<dt>
								<span></span>
							</dt>
							<dd>
								<pre></pre>
							</dd>
						</dl>
					</div>
				</li>
			<%}
			for(ChatDto tmp:list){%>
				<li>
					<div>
						<dl>
							<dt>
								<span><%=tmp.getWriter() %></span>
							</dt>
							<dd>
								<pre><%=tmp.getContent() %></pre>
							</dd>
						</dl>
					</div>
				</li>
			<%}%>
		<%}%>
	</ul>