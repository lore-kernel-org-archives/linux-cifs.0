From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: smb2 work status
Date: Fri, 3 Jun 2011 01:10:22 +0400
Message-ID: <BANLkTik5T2aY4V-Kp-AePZYUR+KgKCyNCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi!

I applied pending smb2 patches on top of current master branch and
created branch smb2-dev:
http://git.etersoft.ru/people/piastry/packages/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev

I also created another branch smb2-dev-experimental and put three
commits on top of smb2-dev - it makes mount/umount work but after some
period of time kernel crashes - I am working on fixing this now:
http://git.etersoft.ru/people/piastry/packages/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev-experimental

Any thoughts/suggestions are welcome!

-- 
Best regards,
Pavel Shilovsky.
