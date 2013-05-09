From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Samba does not return error when deleting non-existent xattr
Date: Thu, 9 May 2013 13:47:57 -0500
Message-ID: <CAH2r5muWS3tHCzyT8zeLx_TYV_+1cDHn2zX0S04h0ODh_zPyjw@mail.gmail.com>
References: <CAH2r5mvsKnot8VkAx=vyRU_z+iLTHq+Vi6UrZyk-TvFEbQ954g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvsKnot8VkAx=vyRU_z+iLTHq+Vi6UrZyk-TvFEbQ954g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

strangely enough Windows server does not seem to return an error on
this (deleting a non-existent attribute) so Samba is probably ok here.

On Wed, May 8, 2013 at 10:12 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> In working on the code to fix the "set zero length xattr deletes the
> xattr" problem - I noticed that Samba does not return an error trying
> to delete an extended attribute that does not exist (locally ext4 does
> return an error when deleting an xattr that does not exist) which made
> it a little harder to notice the kernel client problem at first.
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
