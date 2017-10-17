From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: Share mounts in SMBv1 mode, but fails to mount in SMBv2 mode
Date: Tue, 17 Oct 2017 11:44:32 +0200
Message-ID: <mps4lqyun0f.fsf@aaptelpc.suse.de>
References: <144390dd-e0fc-ae98-a645-5972f11d635d@lal.in2p3.fr> <mpsd15nv1up.fsf@aaptelpc.suse.de> <0b17f092-5c81-3b2e-5e48-b2a4c5b4145a@lal.in2p3.fr> <mpsa80ruowd.fsf@aaptelpc.suse.de> <9e6bb290-6375-2dfe-8d5b-2128fcc9538d@lal.in2p3.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Hadrien Grasland <grasland-dJj/bURytuEtnUBFBimtzg@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9e6bb290-6375-2dfe-8d5b-2128fcc9538d-dJj/bURytuEtnUBFBimtzg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hadrien Grasland <grasland-dJj/bURytuEtnUBFBimtzg@public.gmane.org> writes:
> I've never patched a kernel module before, but I assume it should 
> involve something like getting a copy of my kernel's sources, applying 
> the patch, rebuilding the relevant module, unloading the old module and 
> putting the new one in its place, right?

You can also build the kernel and directly boot the resulting binary in
a qemu vm. You can find many tutorials for this online:

http://ncmiller.github.io/2016/05/14/linux-and-qemu.html
https://www.collabora.com/news-and-blog/blog/2017/01/16/setting-up-qemu-kvm-for-kernel-development/
etc

I'd also suggest using the bridge setup described here so you can access
your host network from the vm transparently.

http://blog.elastocloud.org/2015/07/qemukvm-bridged-network-with-tap.html

Depending on your experience you might find this easier.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
