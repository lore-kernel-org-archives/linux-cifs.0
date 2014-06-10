From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Samba] Read offline attribute
Date: Tue, 10 Jun 2014 12:26:44 -0400
Message-ID: <CAH2r5mvoE8-Pu+Bx0sAN9eweodfun1x2bXDEme9gaYqLY3Umww@mail.gmail.com>
References: <53971D84.1020806@whywouldwe.com> <53971ECD.4070301@whywouldwe.com>
 <20140610173250.1769b200@plati.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Peter Flood <info-O17Z5ZPWbgxgJw1g6a66pQ@public.gmane.org>, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140610173250.1769b200-k1XZOR0ctBLN0uC3ymp8PA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This would be VERY trivial to add - the intent was to allow a query of
the CIFS/SMB3 specific inode metatada via a user xattr (the attribute
was defined as user.DosAttrib).   Probably less than 10 lines of code
to finishup below the following in fs/cifs/xattr.c

if (strncmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0) {
cifs_dbg(FYI, "attempt to query cifs inode metadata\n");
/* revalidate/getattr then populate from inode */

On Tue, Jun 10, 2014 at 11:32 AM, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org> wrote:
> Hi Peter,
>
> On Tue, 10 Jun 2014 16:05:49 +0100, Peter Flood wrote:
>
>> I want to read the 'offline' extended attribute on files on a windows
>> share mounted on a linux host, is it possible to get this info?
>
> The Linux CIFS client doesn't currently offer such support. However,
> the offline attribute can be checked using smbclient via the allinfo
> command. Offline files will carry an 'O' in the attributes field.
>
> Cheers, David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
