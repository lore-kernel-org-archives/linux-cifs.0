From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS Handle extended attribute name cifsacl to generate
 cifs acl blob (try #2)
Date: Fri, 5 Nov 2010 11:13:22 -0500
Message-ID: <AANLkTi=cD8cog9vm0J5n-oqQPAuuB3Dqyhz4SpM0PU84@mail.gmail.com>
References: <1286742716-4467-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101105080106.5d9f4df3@tlielax.poochiereds.net>
	<AANLkTik1by9aWkeoB-7GWtimaG5dAqNbxSB5sKyEnhPn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik1by9aWkeoB-7GWtimaG5dAqNbxSB5sKyEnhPn-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Nov 5, 2010 at 7:01 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
On Sun, 10 Oct 2010 15:31:56 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>  #define MAX_EA_VALUE_SIZE 65535
>  #define CIFS_XATTR_DOS_ATTRIB "user.DosAttrib"
> +#define CIFS_ACL_XATTR "system.cifsacl"
               ^^^^^^^^^^
This should probably be defined in terms of CIFS_XATTR_SYSTEM_PREFIX.
Ditto for CIFS_XATTR_DOS_ATTRIB, even though that wasn't done by

I don't mind either way - there are readability tradeoffs.

Also, NFSv4 uses "system.nfs4_acl". It would be nice to follow that
convention. Maybe rename this "system.cifs_acl" instead?

that makes sense

--
Thanks,

Steve
