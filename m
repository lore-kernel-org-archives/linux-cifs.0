From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Howto mount cifs from c?
Date: Thu, 2 Aug 2012 16:15:54 -0500
Message-ID: <CAH2r5mvS2OHBpu8q60WuXK3L7ys2mx_PRtRa=OEK51FZKdtxQw@mail.gmail.com>
References: <CANXojcz_p23rcNo3gPiAjJ95M0ry+p5Q_5hyYO0TF==0VpKBqg@mail.gmail.com>
	<CANXojczSt+3pyiEH_RoQa4TjA+7H1pmNJrpbJsX3iQA1Vr1O_A@mail.gmail.com>
	<CADT32eJcEm=UnXaCfAva1aXWptxBGEmBAYgeJnqU7nVtC7T4nA@mail.gmail.com>
	<CANXojcwnCQQOEBk3=sM_61Uq7BunLyUvx67WzNGxbRszcgp-fA@mail.gmail.com>
	<CADT32e+Rx3L12ciJXL3VsKnOpsAFiedZXAU78-jZromi7dioNw@mail.gmail.com>
	<CANXojczjroEONLHbmauimAh_M-4ZuHMJ=3LTnHAXMSahc9WMRA@mail.gmail.com>
	<CANXojcy+RapoY9dHXgkaCMr3D7c01bBhiJcxyU2698QwNzY_aA@mail.gmail.com>
	<CADT32eK7WuEASsQ3pUWr9Qj74wRyaGwnEZ10XeQBF-r6d9WHUg@mail.gmail.com>
	<CANXojcyKPGYMv_6iequis+v2d67ozTk7Lw9D0=MY7WWymT=1Nw@mail.gmail.com>
	<20120802161435.7d1564ce@tlielax.poochiereds.net>
	<CANXojczHxNVG5LNb+DR=w92sG5Fto8Vc7O5x9qP8NA-t+xFA1A@mail.gmail.com>
	<20120802162637.2d4fefb5@tlielax.poochiereds.net>
	<CANXojcz5SKpFUpt9h2e60pGZh60ngjiSzxdNLGBp+DfQUJej+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojcz5SKpFUpt9h2e60pGZh60ngjiSzxdNLGBp+DfQUJej+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Doesn't your UNC name have a / instead of a \ between server and share name?

Isn't this simply that you have a bogus UNC (we have a "unc=" parm
because we can't rely on the mount source device to be a properly
formatted unc name)?

mount.cifs.c sets the unc name to standard "universal naming
convention" form ie \\server\share (ie "\\\\" + server_name + "\\" +
share_name and on optional prefix path may follow).
parse_mount_options in the kernel cifs.ko will correct a misformatted
unc name if the slashes before the server name are // rather than \\
but AFAIK does not have a way of fixing a / to \ between the server
name and share name (since it apparently could be valid to some
servers albeit very strange name).

On Thu, Aug 2, 2012 at 3:37 PM, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
> I use:
>
> /* add rw etc*/
>
> len1=sprintf(vfsdata+len0, ",rw,nodfs,unc=");
> len0+=len1;
> /* add the unc */
>
> *(vfsdata+len0)='\\';
> len0++;
> *(vfsdata+len0)='\\';
> len0++;
>
> memcpy(vfsdata+len0, smb_server->name, strlen(smb_server->name));
> len0+=strlen(smb_server->name);
>
> *(vfsdata+len0)='\\';
> len0++;
>
> memcpy(vfsdata+len0, smb_share->name, strlen(smb_share->name));
> len0+=strlen(smb_share->name);
>
> if (strlen(smb_server->ipv4address)>0) {
>
>          /* add ip */
>
>          len1=sprintf(vfsdata+len0, ",ip=%s", smb_server->ipv4address);
>          len0+=len1;
>
> }
> Here I got logmessages:
>
> kernel: fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 118 with uid: 0
> kernel: fs/cifs/connect.c: UNC:
> \\SCLFS20091030\p//SCLFS20091030/public ip:
> SCLFS20091030\p//SCLFS20091030/public
>
> which is also bogus.
>
> I think I'm not the person to remove the unc from the kernel with a
> patch...but I think it's not required anymore, it adds nothing.
> Right now it's required by the cifs module still as I checked.
>
> I think there is something wrong with parsing the backslashes. They
> should be forbidden. Some hint?
>
> Stef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
