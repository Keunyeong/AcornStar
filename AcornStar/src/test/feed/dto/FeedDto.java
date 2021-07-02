package test.feed.dto;

public class FeedDto {
	private int num;
	private String writer;
	private String tag;
	private String content;
	private int upCount;
	private String regdate;
	
	public FeedDto() {}

	public FeedDto(int num, String writer, String tag, String content, int upCount, String regdate) {
		super();
		this.num = num;
		this.writer = writer;
		this.tag = tag;
		this.content = content;
		this.upCount = upCount;
		this.regdate = regdate;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public String getTag() {
		return tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public int getUpCount() {
		return upCount;
	}

	public void setUpCount(int upCount) {
		this.upCount = upCount;
	}

	public String getRegdate() {
		return regdate;
	}

	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}
}
