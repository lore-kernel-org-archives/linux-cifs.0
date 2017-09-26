From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] man: generate all man pages from POD files when buidling
Date: Tue, 26 Sep 2017 16:50:35 +0200
Message-ID: <mpsd16dsedg.fsf@aaptelpc.suse.de>
References: <20170920222053.7977-1-aaptel@suse.com> <1506431475.3182.4.camel@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeffrey Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506431475.3182.4.camel-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeffrey Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> writes:
> Looks reasonable to me, overall. Do we need a new autoconf test for
> pod2man?
>
> What should we do if the build host doesn't have it installed? Error
> out, or disable building the docs?

The latter sounds better. I'll send v2 of this patch.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
