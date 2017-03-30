From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aurelien.aptel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix build failure with smb2
Date: Thu, 30 Mar 2017 13:47:38 +0200
Message-ID: <mps1stfhtph.fsf@aaptelpc.suse.de>
References: <20170330103414.19972-1-tobias.regnery@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Tobias Regnery <tobias.regnery-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Tobias Regnery <tobias.regnery-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170330103414.19972-1-tobias.regnery-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Tobias Regnery <tobias.regnery-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> Explicit include the right header to fix this issue.

uuid.h indeed declares generate_random_uuid(). Looks good to me.

Reviewed-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
