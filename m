From: Cong Monkey <congzhangzh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Is that possible follow symbol link location which point with full location
Date: Mon, 29 Aug 2016 22:42:02 +0800
Message-ID: <CAOXDmPr9tgNVQFJOpurtfH6+C3gRa5nej=uKpzXmvHY6m6d6hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

HI All,
    I try to mount.cifs a windows server share on debian, it works well.
    But, I have trobule with symbol directory which create with mklink /D
abc  \\thesameserver\ddd\eee, and it works if the link create with mklink
/D abc  ddd\eee.
    My question is, is mount.cifs possible to work full path symbol link?
    Thanks,
Cong
