From: =?UTF-8?Q?Johannes_Thr=C3=A4n?= <johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: confusing errormessages from cifs
Date: Thu, 13 Oct 2011 16:00:37 +0200
Message-ID: <CAFbNW2F7NU5BM5YpPEOko-MomQ3LdUk2EJA6FEY4fkOQ8dj1mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

mounting cifs-shares could be a little bit more user friendly/less
confusing/wrong:

 - when I give mount.cifs a hostname which is neither a UNC-servername nor
listed in /etc/hosts (like mount -t cifs //alice/mount /mountpoint
with no entry "alice" in /etc/hosts) it tells me:
"mount error: could not resolve address for...", which is ok and
suggests mount.cifs uses /etc/hosts.

But:
- when I give mount.cifs a hostname, which is listed in /etc/hosts but
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
