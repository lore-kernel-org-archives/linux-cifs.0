From: =?UTF-8?Q?Johannes_Thr=C3=A4n?= <johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: cifs doesn't resolve names in /etc/hosts, error message very confusing
Date: Wed, 7 Sep 2011 19:37:17 +0200
Message-ID: <CAFbNW2G+Hteyon=U7OMAy8Ugf_jpG5Kiot0SAYxXSsQ=-BpZgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

Today I had to mount a windows share from a Win2k3 computer onto my
kubuntu 11.xx.

I tried the following

sudo mount -t cifs -o username=username //servername/share /mnt/test/

after I entered the password, it didn't work with the error message:

mount error(5): Input/output error

my /var/log/kern.log stated

Sep  7 18:36:08 zipfl kernel: [451267.341083] CIFS VFS: Unexpected SMB signature
Sep  7 18:46:41 zipfl kernel: [451900.421030] CIFS VFS: cifs_mount
failed w/return code = -5

After literally hours I tried the IP instead of the "servername" and it worked.
My mistake was to put a "IP servername" entry in /etc/hosts and
thought mount.cifs would understand this "servername" as ssh and
everybody else does.
(the fact that the syntax uses // instead of the windows \\ perhaps
somehow took me in that direction, despite the manpage clearly states
"UNC-name")

Ok, my fault, but:

Cifs seems to recognize the name halfway (which is at least quirky)
and confused me to kingdom come with inconsistent error messages:

 - when I give cifs a hostname which is neither a UNC-servername nor
listed in /etc/hosts it tells me
"mount error: could not resolve address for...", which is good.

- when I give cifs a hostname, which is listed in /etc/hosts but
doesn't refer to an existing UNC-servername it tells me
"mount error(5): Input/output error", which is at least unclear (I
thought the server might use a deprecated/buggy/unsupported
smb-version)

- even more confusing: when I give cifs a hostname, which is listed in
/etc/hosts but doesn't refer to an existing UNC-servername AND supply
a mistyped password it tells me

"mount error(13) : Permission denied"

,which is very misleading, because I think there's something wrong
with my credentials AND makes me think the hostname gets resolved
correctly whereas the opposite is the case.

could you please make those things more clear. It would really have
saved me at least 2 hours of googling and banging my head against the
desk.

Regards, Johannes
