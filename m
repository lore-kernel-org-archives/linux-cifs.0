From: Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: Re: [PATCH v7 0/7] Add O_DENY* support for VFS and CIFS/NFS
Date: Tue, 21 Jan 2014 15:17:08 +0100
Message-ID: <E1W5c8k-0036ba-7A@intern.SerNet.DE>
References: <1389953232-9428-1-git-send-email-piastry@etersoft.ru>
 <E1W5A0e-000MT9-A1@intern.SerNet.DE>
 <CAKywueQwfFASPpevO8Z-_xwZqRjkzfkOceQJDya8D7FDW+UmMg@mail.gmail.com>
 <E1W5C8U-000ozD-Ku@intern.SerNet.DE>
 <CAKywueQng9=u1YYwkYGCunWW8RBhARhJjEhBcoA6CKF6TrKSBg@mail.gmail.com>
Reply-To: Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux NFS Mailing list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date: Tue, 21 Jan 2014 15:17:08 +0100
Content-Disposition: inline
In-Reply-To: <CAKywueQng9=u1YYwkYGCunWW8RBhARhJjEhBcoA6CKF6TrKSBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 21, 2014 at 05:31:39PM +0400, Pavel Shilovsky wrote:
> It's not possible with the current API to do it through open syscall.
> Another possibility is to look at /proc/locks. But I think we really
> need O_DELETE flag that will force a file to be removed on close - we
> will be able to do O_DENYDELETE checks atomically.

I don't depend on this at open time. I can do it later with
some syscall, that's fine. I just want to find a way to do
it correctly. The problem is -- you can't "try" an unlink.
So we have to probe whether we can unlink. And opening for
O_DENYDELETE by no means says we *will* unlink. We just have
to keep the option to do it exclusively.

With best regards,

Volker

--=20
SerNet GmbH, Bahnhofsallee 1b, 37081 G=F6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=F6ttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org
