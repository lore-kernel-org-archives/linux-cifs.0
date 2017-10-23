From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] man: generate all man pages from POD files when buidling
Date: Mon, 23 Oct 2017 16:23:02 +0200
Message-ID: <mps8tg2t03d.fsf@aaptelpc.suse.de>
References: <20170920222053.7977-1-aaptel@suse.com> <20170929140303.24880-1-aaptel@suse.com> <1508761900.5859.10.camel@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508761900.5859.10.camel-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> writes:
> A one time conversion to rst files and twiddle the Makefile.am to use
> rst2man and I think we'd be done. I'm happy to do the work, but I wanted
> to run it by you in case you had a particular attachment to pod files.

I've just picked POD because there was already POD files in the
tree. You can go ahead if you prefer RST, I personally don't mind much
as long as it's not troff :)

Cheers,

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
