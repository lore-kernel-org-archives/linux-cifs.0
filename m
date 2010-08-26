From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: build warning after merge of the cifs tree
Date: Wed, 25 Aug 2010 21:07:08 -0500
Message-ID: <AANLkTikvKchHEFR_F-Fdo6Z8n2XKbi4tRh0eYnjzVQJ9@mail.gmail.com>
References: <20100826110229.931ab5bf.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100826110229.931ab5bf.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 25, 2010 at 8:02 PM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>
> fs/cifs/sess.c: In function 'CIFS_SessSetup':
> fs/cifs/sess.c:623: warning: unused variable 'ntlmsspblob'
>
> Introduced by commit 9fbc590860e75785bdaf8b83e48fabfe4d4f7d58 ("[CIFS]
> Fix ntlmv2 auth with ntlmssp").

Shirish's patch doesn't use that local variable when experimental is
off - I will talk to him about simply moving the local variable to
eliminate the unused variable warning.


-- 
Thanks,

Steve
