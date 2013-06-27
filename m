From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount error 79 = Can not access a needed shared library
Date: Thu, 27 Jun 2013 16:15:45 -0500
Message-ID: <CADT32eJbSsGYP7a8qMvvtB=e0L0935hp9NFG+kaBfAHjV2VwFQ@mail.gmail.com>
References: <51CCA586.1070105@towo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Thomas Wolff <towo-JHPtuYzOr/0@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CCA586.1070105-JHPtuYzOr/0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

What is the output of command the  dmesg?  Does lsmod show nls_utf8
as one of the loaded modules?  You can try modprobe nls_utf8 and check
with lsmod whether it is loaded or not!

On Thu, Jun 27, 2013 at 3:50 PM, Thomas Wolff <towo-JHPtuYzOr/0@public.gmane.org> wrote:
> My attempt to mount with -o iocharset=utf8 fails with this message:
> mount error 79 = Can not access a needed shared library
>
> By google, I found one hint to "compile and install" nls_utf8.ko but without
> a mention of where to get that from or how to proceed anyway (very funny).
>
> The system is Debian on a ppc, uname -a:
> Linux MyBookLive 2.6.32.11-svn21605 #1 Fri Oct 15 17:13:23 PDT 2010 ppc
> GNU/Linux
>
> aptitude search does not show any useful results for nls
>
> ------
> Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
