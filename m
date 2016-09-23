From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Recent CIFS/SMB3 fixes from the plugfest
Date: Fri, 23 Sep 2016 02:24:22 -0500
Message-ID: <CAH2r5msku=Y_k_p9fE6qyz-6ahBCamEetf=yvT0wXcxBmHf67A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David Goebel (AZURE)" <davidgoe-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>,
        Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks to Aurelien, Germano (and Ross) for help with recent cifs/smb3
fixes and good progress at the SMB3 plugfest this week.   11 fixes
checked in so far to cifs-2.6 for-next.  More review would be
appreciated.  We are still working on improvements to ACL support
(including being able to optionally emulate uid/gid ownership from
special sids as JRA suggested), ways to query some additional metadata
(via ioctls or xattrs), and hopefully encryption support and some
performance optimizations.

sfrench@ubuntu:~/cifs-2.6$ git log --pretty=short -11
commit 659f6f19d31164de895ae3ed6b3914b1e6c162d6
Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

    SMB3:  Add mount parameter to allow user to override max credits

commit 162da7678426d5ec5c1bc6d0cde02be481a6ea1b
Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

    fs/cifs: reopen persistent handles on reconnect

commit ad5127848355e16243e04faae7e053ddb34c3dac
Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

    [CIFS] Clarify locking of cifs file and tcon structures and make
more granular

commit de5233745cd59cf5853d963ad216067788a87594
Author: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

    Fix regression which breaks DFS mounting

commit 06dc82f1ce3d4d9da2571e6fa7c7ea8c18e0ca6f
Author: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>

    fs/cifs: keep guid when assigning fid to fileinfo

commit 17476d9818d49dcda9c6dcbc80ef7e7f67ba5a3b
Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

    SMB3: GUIDs should be constructed as random but valid uuids

commit e1df6cab7969a89f41b3d99a944ea58837ec35e6
Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

    Set previous session id correctly on SMB3 reconnect

commit 44c57e921faf40aa4bca61c223147e458730166f
Author: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>

    cifs: Limit the overall credit acquired

commit ad97c0a245667982aac7a40cd91c5462e3d2a4e8
Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

    [SMB3] Display number of credits available

commit 12981ea922bae13b443a727126b183273bde3587
Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

    [CIFS] Add way to query creation time of file via cifs xattr

commit 7ad21be52ff3bbab09bc987d2491eed8088c63a1
Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

    Add way to query file attributes via cifs xattr


-- 
Thanks,

Steve
