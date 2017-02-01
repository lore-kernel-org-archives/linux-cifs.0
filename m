From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: smbcmp: new tool to compare SMB traces
Date: Wed, 01 Feb 2017 11:37:29 +0100
Message-ID: <mpsh94ejixi.fsf@aaptelpc.suse.de>
References: <mpspoj3jrtv.fsf@aaptelpc.suse.de> <CAH2r5mtox_==O1oWq1wik6_wgZ7o56JVNZ_wXcxx87fE79xsHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtox_==O1oWq1wik6_wgZ7o56JVNZ_wXcxx87fE79xsHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> This is a great idea - why don't we merge this into Samba git tree, so
> it can be packaged in one of the client/tools rpms?

I think it makes more sense to have a separate repo. I don't like to do
the dance where I'm working on commit X but want the tool in the same
tree at its latest version.

We have a package for openSUSE here [1], it should be simple to adapt
for other distros.

1: https://build.opensuse.org/package/show/home:dmulder/smbcmp

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
