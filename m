From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs: chown/chgrp id/sid mapping (try #4)
Date: Mon, 22 Aug 2011 08:32:38 -0500
Message-ID: <CADT32eLyXUtP5iSi_Ym1h=3b6pLpv20nUMgbp_PFYMZ8mh7iWw@mail.gmail.com>
References: <1312918219-23688-1-git-send-email-shirishpargonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1312918219-23688-1-git-send-email-shirishpargonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Aug 9, 2011 at 2:30 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> chown/chmod commands for mount option cifsacl.
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>
> This patchset aim to enable chown and chgrp commands when
> cifsacl mount option is specified, especially to Windows SMB servers.
> Currently we can't do that. =A0So now along with chmod command,
> chown and chgrp work.
>
> Winbind is used to map id to a SID. =A0chown and chgrp use an upcall
> to provide an id to winbind and upcall returns with corrosponding
> SID if any exists. That SID is used to build security descriptor.
> The DACL part of a security descriptor is not changed by either
> chown or chgrp functionality.
>
> cifs client maintains a separate caches for uid to SID and
> gid to SID mapping. This is similar to the one used earlier
> to map SID to id (as part of ID mapping code).
>
> I tested it by mounting shares from a Windows (2003) server by
> authenticating as two users, one at a time, as Administrator and
> as a ordinary user.
> And then attempting to change owner of a file on the share.
>
> Depending on the permissions/privileges at the server for that file,
> chown request fails to either open a file (to change the ownership)
> or to set security descriptor.
> So it all depends on privileges on the file at the server and what
> user you are authenticated as at the server, cifs client is just a
> conduit.
>
> I compared the security descriptor during chown command to that
> what smbcacls sends when it is used with -M OWNNER: option
> and they are similar.
>
> This patchset aim to enable chown and chgrp commands when
> cifsacl mount option is specified, especially to Windows SMB servers.
> Currently we can't do that. =A0So now along with chmod command,
> chown and chgrp work.
>
> I tested it by mounting shares from a Windows (2003) server by
> authenticating as two users, one at a time, as Administrator and
> as a ordinary user.
> And then attempting to change owner of a file on the share.
>
> Depending on the permissions/privileges at the server for that file,
> chown request fails to either open a file (to change the ownership)
> or to set security descriptor.
> So it all depends on privileges on the file at the server and what
> user you are authenticated as at the server, cifs client is just a
> conduit.
>
>


Jeff, Steve,

Any comments on these (2/3 and 3/3)?  patch 1/3 has been merged.

Regards,

Shirish
