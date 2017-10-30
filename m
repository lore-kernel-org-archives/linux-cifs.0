From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [cifs-utils PATCH] manpage: update mount.cifs manpage with info about default version being mounted
Date: Mon, 30 Oct 2017 12:01:39 +0100
Message-ID: <mpswp3cj3vw.fsf@aaptelpc.suse.de>
References: <20171029105809.8954-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171029105809.8954-1-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jeff,

Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
> +  In kernels v4.13 and later, the default is ``3.0``. In kernels prior to
> +  v4.13, the default is ``1.0``.
> +

IIUC, the current default is actually to negotiate and automatically use
2.1 or above.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
