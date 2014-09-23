From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] [SMB3] Allow mknod and mkfifo on SMB2/SMB3 mounts
Date: Mon, 22 Sep 2014 22:40:41 -0700
Message-ID: <20140923054041.GA30374@infradead.org>
References: <CAH2r5msJdxod3Y3LTjdrhOnn+w+hQ7TnuuifsoyJtuyBp6jJkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msJdxod3Y3LTjdrhOnn+w+hQ7TnuuifsoyJtuyBp6jJkA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Is there any good reason to require a mount option for these extensions?
