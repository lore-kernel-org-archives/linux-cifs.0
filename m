From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: -o noposixpaths
Date: Mon, 11 Jul 2011 13:32:54 -0500
Message-ID: <CAH2r5mv3WOCKk4jL1YXrfvSjt52NOTgJZKatbLqB4U61iuZxRg@mail.gmail.com>
References: <20110711142311.27b4dfce@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110711142311.27b4dfce-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Yes, IIRC the apple guys mentioned plausible server scenarios for this
(where we want to mount with unix extensions for symlinks and ownership
but server can not handle posix path names)

Presumably if the server file system does not support posix path names
(FAT32, NTFS?) or if we want to restrict the characters (for interopera=
bility
with Windows clients accessing the same share?) - might be other cases.

On Mon, Jul 11, 2011 at 1:23 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Is this mount option actually useful? Is there ever a case where we'd
> want to use unix extensions, but not use posix-style pathnames? If no=
t,
> does it make sense to deprecate this option?
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
