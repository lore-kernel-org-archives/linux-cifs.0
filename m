From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: Share mounts in SMBv1 mode, but fails to mount in SMBv2 mode
Date: Mon, 16 Oct 2017 12:11:42 +0200
Message-ID: <mpsd15nv1up.fsf@aaptelpc.suse.de>
References: <144390dd-e0fc-ae98-a645-5972f11d635d@lal.in2p3.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Hadrien Grasland <grasland-dJj/bURytuEtnUBFBimtzg@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <144390dd-e0fc-ae98-a645-5972f11d635d-dJj/bURytuEtnUBFBimtzg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hadrien Grasland <grasland-dJj/bURytuEtnUBFBimtzg@public.gmane.org> writes:
> I can also provide a wireshark capture of the client-server traffic or 
> ask for details of server configuration if you need that. For the later, 
> please keep in mind that I'm a total CIFS newbie and be specific about 
> what you want to know.

Yes this would be helpful.

    # make the kernel as verbose as possible
    echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
    echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
    echo 1 > /proc/fs/cifs/cifsFYI
    echo 1 > /sys/module/dns_resolver/parameters/debug

    # get kernel output + network trace
    dmesg --clear
    tcpdump -w trace.pcap & pid=$!
    sleep 3
    mount.cifs ....cd ... ls.. blahblah
    sleep 3
    kill $pid
    dmesg > trace.log

this should produce a trace.pcap and trace.log file.

If the server is a samba server, the /etc/samba/smb.conf would be
helpful.

Cheers,

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
