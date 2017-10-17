From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: Share mounts in SMBv1 mode, but fails to mount in SMBv2 mode
Date: Tue, 17 Oct 2017 11:28:38 +0200
Message-ID: <mps7evuunqx.fsf@aaptelpc.suse.de>
References: <144390dd-e0fc-ae98-a645-5972f11d635d@lal.in2p3.fr> <mpsd15nv1up.fsf@aaptelpc.suse.de> <0b17f092-5c81-3b2e-5e48-b2a4c5b4145a@lal.in2p3.fr> <mpsa80ruowd.fsf@aaptelpc.suse.de> <9e6bb290-6375-2dfe-8d5b-2128fcc9538d@lal.in2p3.fr> <CAH2r5mt+pRqKa+drXNUEZwhK4bJBH9AYyu048QpSkBnqd_XXgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: "linux-cifs\@vger.kernel.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Hadrien Grasland <grasland-dJj/bURytuEtnUBFBimtzg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt+pRqKa+drXNUEZwhK4bJBH9AYyu048QpSkBnqd_XXgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> Yes.  One option we have is to fall back to a lower, less complete info level
> to work around this server bug.

Ok

What do you think about the extra null byte and the wrong offset in the
query info request? It definitely looks like an error to me.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
