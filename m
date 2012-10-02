From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: BUG 36952 CIFS VFS: Unexpected SMB signature
Date: Mon, 1 Oct 2012 21:36:01 -0400
Message-ID: <20121001213601.25ec2ddd@corrin.poochiereds.net>
References: <1974852427.1436977.1349126989564.JavaMail.www@wwinf8223>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1974852427.1436977.1349126989564.JavaMail.www@wwinf8223>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 01 Oct 2012 23:29:49 +0200
"sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org> wrote:

> Hello everybody,
> 
> I was wondering if the bug has been patched and from which kernel the patch is 
> integrated.
> 
> CIFS VFS: Unexpected SMB signature
> https://bugzilla.kernel.org/show_bug.cgi?id=36952
> 
> I have 300 up to date Fedora 15 clients with the bug. And I am wondering what to do ?
> Upgrade kernel, upgrade distrib, change module cifs.ko ?
> 
> If anybody has an idea, it would be great !
> 
> Thanks in advance .
> Serge CONRAD
> 

That particular bug was fixed quite some time ago. However, the
"Unexpected SMB signature" message can pop up for all sorts of reasons.
You'd need to do some analysis to determine the cause in your case.

It may be easier though to test a recent mainline kernel first and see
if you can reproduce the problem with it.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
