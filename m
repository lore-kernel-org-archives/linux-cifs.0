From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: Regression in 4.14-rc: CIFS SMB2+ combined with pythons xattr.listxattr leads to "IOError: [Errno 61] No data available"
Date: Wed, 18 Oct 2017 14:52:58 +0200
Message-ID: <mpsshegty6t.fsf@aaptelpc.suse.de>
References: <4d13dddc-2df2-4112-a214-15700c22ed50@leemhuis.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4d13dddc-2df2-4112-a214-15700c22ed50-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Thorsten,

If you still run into this problem, could you provide a network trace
and kernel output?

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

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
