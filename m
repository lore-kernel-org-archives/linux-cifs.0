From: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>
Subject: Re: [PATCH linux-next V2] cifs: Make big endian multiplex ID sequences
 monotonic on the wire
Date: Fri, 01 Nov 2013 12:04:44 -0700
Message-ID: <5273FB4C.5010002@tpi.com>
References: <1381941162-72831-1-git-send-email-timg@tpi.com> <CAH2r5mt5kBDR1oZfDNVu+bd7-jf=zQ6tBm2YjKXKBwdYE+YG=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt5kBDR1oZfDNVu+bd7-jf=zQ6tBm2YjKXKBwdYE+YG=w@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/01/2013 11:50 AM, Steve French wrote:
> This has a couple of obvious endian errors.  I will correct your patch
> and remerge into cifs-2.6.git for-next
> 
> Please always remember to run endian checks against cifs builds when
> submitting a patch (and make sure sparse is installed)
> 
> e.g.
> 
> make C=1 M=fs/cifs modules CF=-D__CHECK_ENDIAN__
> 

Didn't know about __CHECK_ENDIAN__, but will do so in the future. Your
changes look fine.

rtg
-- 
Tim Gardner timg-l6nL5VImRDY@public.gmane.org www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
