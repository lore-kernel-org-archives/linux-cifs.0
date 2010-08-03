From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2.6.32/stable] CIFS: Remove __exit mark from cifs_init_dns_resolver() header
Date: Tue, 03 Aug 2010 22:40:25 +0100
Message-ID: <12482.1280871625@redhat.com>
References: <19826.1280811821@neuling.org> <19789.1280811783@neuling.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <19826.1280811821-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org> wrote:

> An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this error
> 
> fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_init_dns_resolver'
> 
> This removes the __init from cifs_init_dns_resolver()

That's not really a good idea as the assembler may choose different pieces of
assembly to do variable references and jumps, depending on the section
information.

A better fix is to add:

	#include <linux/module.h>

to the header file.

David
