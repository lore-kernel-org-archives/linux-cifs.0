From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [SMB3] Allow mknod and mkfifo on SMB2/SMB3 mounts
Date: Mon, 22 Sep 2014 22:53:51 -0700
Message-ID: <CAH2r5mt0yJNkjEXd5GxUef6iw=odftNFsVO_fakwaDpXoCFp6A@mail.gmail.com>
References: <CAH2r5msJdxod3Y3LTjdrhOnn+w+hQ7TnuuifsoyJtuyBp6jJkA@mail.gmail.com>
 <20140923054041.GA30374@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140923054041.GA30374-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I am ok with not requiring a mount option (at least for smb3) with the
goal of making these more intuitive.  For cifs mounts, perhaps better
not to change existing behavior.

On Mon, Sep 22, 2014 at 10:40 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> Is there any good reason to require a mount option for these extensions?
>



-- 
Thanks,

Steve
