From: Robert Kudyba <rkudyba-tzaSEmCkE7qVc3sceRu5cw@public.gmane.org>
Subject: Re: Fwd: backing up to a Drobo CIFS VFS: Error -11 sending data on
 socket to server, Bufferbloat?
Date: Fri, 12 May 2017 09:45:16 -0400
Message-ID: <CAFHi+KSXEgQ-Zmm-EYwvJzOWm6cSPTi5L0WxurUTr_2EHoVa4A@mail.gmail.com>
References: <B0AAEC04-DBAE-49AB-A549-B772D5F1B7F6@fordham.edu>
 <D5627D5A-065B-4C28-B152-7B0A587A0CBF@fordham.edu> <CACyXjPzG4L3Px8ws+CQkh0K6xwB7Kd6tCC7zSO0C11j4SWHY1w@mail.gmail.com>
 <CAFHi+KS6HtBGvqTJxNgMYvBaYnibryf==5x8FTJfGtjMJOSkBA@mail.gmail.com>
 <CAFHi+KRGNSvfgj7o+tK0RZZa9Nf2NQANUiygsUR5aokJH5NP7w@mail.gmail.com>
 <CAFHi+KSB348xPhYSf=x7FW9kmgU5iN-mDGvs2Fhyv=UYCMQckw@mail.gmail.com>
 <CAFHi+KRjK-pLxr+gNkE0jpsM1YfgE4s2Lw8Q4XTSTP-V0_Ds8A@mail.gmail.com>
 <CAFHi+KQhXFrOVDb51fZCs1e5ik3RY+v91H5Sz1Z3YkgUpMPURw@mail.gmail.com> <mpsinl6cn2g.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpsinl6cn2g.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> Given your kernel log message I would expect seeing the reconnecting happ=
en.

I scheduled a tshark -c over night and was able to get it to run
within minutes of the reconnect attempts.It seems pretty consistent,
about 2 hours after the start of the cron the Error -11's start to
happen. Last night it also happened about 30 minutes into the job:

May 11 23:47:51 localworkstation kernel: CIFS VFS: Server drobo-rh has
not responded in 120 seconds. Reconnecting...
May 11 23:49:59 localworkstation kernel: CIFS VFS: Server drobo-rh has
not responded in 120 seconds. Reconnecting...
May 11 23:52:57 localworkstation kernel: CIFS VFS: Server drobo-rh has
not responded in 120 seconds. Reconnecting...

May 12 01:19:44 localworkstation cupsd: REQUEST localhost - - "POST /
HTTP/1.1" 200 181 Renew-Subscription successful-ok
May 12 01:21:20 localworkstation kernel: CIFS VFS: sends on sock
ffff9f2817bede00 stuck for 15 seconds
May 12 01:21:20 localworkstation kernel: CIFS VFS: Error -11 sending
data on socket to server

Here's the tshark -r tshark.pcap -Y 'smb||smb2' results from 2 files:

  593 0.273687063 drobo =E2=86=92 localserver SMB 117 [TCP ACKed unseen
segment] Write AndX Response, 65536 bytes
  666 0.282264835 drobo =E2=86=92 localserver SMB 117 Write AndX Response, =
65536 bytes
    8 0.136979937 drobo =E2=86=92 localserver SMB 117 [TCP ACKed unseen
segment] [TCP Previous segment not captured] Write AndX Response,
65536 bytes
   36 0.142752037 drobo =E2=86=92 localserver SMB 117 Write AndX Response, =
65536 bytes
   63 0.149017707 drobo =E2=86=92 localserver SMB 117 Write AndX Response, =
65536 bytes

> I would wrap your backup script like so to get the right capture:
>
>     capfile=3D"$(date -Ihours)"
>     tcpdump -w "$capfile" port 445 &
>     cappid=3D$!
>     sleep 2
>     .....<your script>....
>     sleep 2
>     kill -6 $cappid

OK just did that and started running the backup manually so far I've
seen variations/multiples of these (cut for easier reading):
38735  18.521926 localserver =E2=86=92 drobo SMB 10202 Write AndX Request,
FID: 0x1fca, 65536 bytes at offset 87949312[TCP segment of a
reassembled PDU]
38760  18.527189 localserver =E2=86=92 drobo SMB 7306 Write AndX Request, F=
ID:
0x1fca, 65536 bytes at offset 88014848[TCP segment of a reassembled
PDU]
38771  18.529817 drobo =E2=86=92 localserver SMB 117 Write AndX Response, F=
ID:
0x1fca, 65536 bytes
44079  19.615349 drobo =E2=86=92 localserver SMB 117 [TCP ACKed unseen
segment] Write AndX Response, 65536 bytes
44102  19.626642 drobo =E2=86=92 localserver SMB 117 [TCP ACKed unseen
segment] Write AndX Response, 65536 bytes
