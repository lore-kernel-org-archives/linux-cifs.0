From: Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: Re: [PATCH v7 0/7] Add O_DENY* support for VFS and CIFS/NFS
Date: Mon, 20 Jan 2014 11:31:13 +0100
Message-ID: <E1W5C8U-000ozD-Ku@intern.SerNet.DE>
References: <1389953232-9428-1-git-send-email-piastry@etersoft.ru>
 <E1W5A0e-000MT9-A1@intern.SerNet.DE>
 <CAKywueQwfFASPpevO8Z-_xwZqRjkzfkOceQJDya8D7FDW+UmMg@mail.gmail.com>
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
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date: Mon, 20 Jan 2014 11:31:13 +0100
Content-Disposition: inline
In-Reply-To: <CAKywueQwfFASPpevO8Z-_xwZqRjkzfkOceQJDya8D7FDW+UmMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Jan 20, 2014 at 02:20:43PM +0400, Pavel Shilovsky wrote:
> > One question: If Samba wants to open a file for delete
> > access, there's no corresponding flag in the open
> > permissions. There can be the case where Samba wants to open
> > *just* for future unlink, no read or write access required.
> > Is there a way to achieve this atomically correct?
>=20
> You can try to use O_PATH flag. It doesn't give you a delete access
> but should be ok because further deleting will be done without file
> descriptor -- through unlink syscall.

Ok, I did not know about O_PATH. Thanks for that!

So I do an open with O_PATH. How do I then make sure that
nobody else has a O_DENYDELETE set without doing the unlink
itself?

Thanks,

Volker

--=20
SerNet GmbH, Bahnhofsallee 1b, 37081 G=F6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=F6ttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
