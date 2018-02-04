From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [SMB3][PATCH] Address the remaining sparse warning in new smbdirect code
Date: Sat, 3 Feb 2018 19:52:13 -0600
Message-ID: <CAH2r5muxQSY7j2vTPttd6R89QBwjMfnynE=19TjnCb5JV+20fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Even if one of these was a sparse bug (or being overly strict),
it is worth fixing to quiet the builds (when smbdirect is enabled):

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=0e0b7d209c8ff56610629bd0bf0edc5c4e1e41a2

-- 
Thanks,

Steve
