From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: Fwd: backing up to a Drobo CIFS VFS: Error -11 sending data on socket to server, Bufferbloat?
Date: Fri, 12 May 2017 13:49:11 +0200
Message-ID: <mpsinl6cn2g.fsf@aaptelpc.suse.de>
References: <B0AAEC04-DBAE-49AB-A549-B772D5F1B7F6@fordham.edu> <D5627D5A-065B-4C28-B152-7B0A587A0CBF@fordham.edu> <CACyXjPzG4L3Px8ws+CQkh0K6xwB7Kd6tCC7zSO0C11j4SWHY1w@mail.gmail.com> <CAFHi+KS6HtBGvqTJxNgMYvBaYnibryf==5x8FTJfGtjMJOSkBA@mail.gmail.com> <CAFHi+KRGNSvfgj7o+tK0RZZa9Nf2NQANUiygsUR5aokJH5NP7w@mail.gmail.com> <CAFHi+KSB348xPhYSf=x7FW9kmgU5iN-mDGvs2Fhyv=UYCMQckw@mail.gmail.com> <CAFHi+KRjK-pLxr+gNkE0jpsM1YfgE4s2Lw8Q4XTSTP-V0_Ds8A@mail.gmail.com> <CAFHi+KQhXFrOVDb51fZCs1e5ik3RY+v91H5Sz1Z3YkgUpMPURw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Robert Kudyba <rkudyba-tzaSEmCkE7qVc3sceRu5cw@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFHi+KQhXFrOVDb51fZCs1e5ik3RY+v91H5Sz1Z3YkgUpMPURw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Robert,

The capture you posted unfortunately does not contain anything of worth
looking at I think. Only 2 SMB packets.

% tshark -r capture.pcap -Y 'smb||smb2'
   1130  15.032933 150.108.64.56 → 150.108.68.23 SMB 144 Trans2 Request, QUERY_PATH_INFO, Query File All Info, Path:
   1131  15.034786 150.108.68.23 → 150.108.64.56 SMB 204 Trans2 Response, QUERY_PATH_INFO

Given your kernel log message I would expect seeing the reconnecting happen.

I would wrap your backup script like so to get the right capture:

    capfile="$(date -Ihours)"
    tcpdump -w "$capfile" port 445 &
    cappid=$!
    sleep 2
    .....<your script>....
    sleep 2
    kill -6 $cappid


-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
