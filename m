From: Andi Shyti <andi-ahk0KpmfxKRAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: file: initialize oparms.reconnect before using
 it
Date: Mon, 29 Jul 2013 10:33:25 +0200
Message-ID: <20130729083325.GA1948@jack.whiskey>
References: <CAH2r5msP8+qZnb38Rj5WMWmqWFtopmoe671G6TNTB=61BvYEnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Andi Shyti <andi-ahk0KpmfxKRAfugRpC6u6w@public.gmane.org>, mikko.rapeli-X3B1VOXEql0@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msP8+qZnb38Rj5WMWmqWFtopmoe671G6TNTB=61BvYEnA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

> Your patch looks reasonable.   Would you repost the patch to
> linux-cifs mailing list (and add any additional reviewers or testers
> if you would like if you got feedback)?

Thanks for your mail,

Actually linux-cifs is on CC and this is the output of
get_maintainer:

Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> (supporter:COMMON INTERNET F...)
linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:COMMON INTERNET F...)
samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org (moderated list:COMMON INTERNET F...)
linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list)

All are on CC. get_maintainers, indeed sometimes is not very
precise since gets the CC list by doing a git blame on the file
and adding the ones who previously modified the specific lines.

If this patch got lost I could enrich my To/Cc list by looking at
git shortlog and more carefully at git blame.

Thanks,
Andi
