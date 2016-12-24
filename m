From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Sat, 24 Dec 2016 14:04:33 -0600
Message-ID: <CAH2r5mvOVdFb6HCMR4PuFXTVPQjd7qT4J6uC4VZ9Px6kVB6GDg@mail.gmail.com>
References: <CAH2r5mvhe=P7okz2O6i962HjbVMdR+0XRjKCw6OsNqeVzrgDHQ@mail.gmail.com>
 <CA+55aFzEJ3ZJaojOZcanmkUigSJQeSZE+xLXikbUPD=6VAKavw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzEJ3ZJaojOZcanmkUigSJQeSZE+xLXikbUPD=6VAKavw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Was my cut-and-paste error (left off last few lines), not "git
request-pull's" fault.  Complete output below (including last few
lines that weren't copied into the email).  Sorry about that


The following changes since commit 43c4f67c966deb1478dc9acbf66ab547287d530f:

  Merge branch 'akpm' (patches from Andrew) (2016-11-30 16:33:41 -0800)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 374402a2a1dfbbee8ab1a5a32ec4887bf8c15d52:

  cifs_get_root shouldn't use path with tree name (2016-12-15 01:42:54 -0600)

----------------------------------------------------------------
Andy Lutomirski (1):
      cifs: Fix smbencrypt() to stop pointing a scatterlist at the stack

Germano Percossi (1):
      Fix default behaviour for empty domains and add domainauto option

Pavel Shilovsky (5):
      CIFS: Decrease verbosity of ioctl call
      CIFS: Fix missing nls unload in smb2_reconnect()
      CIFS: Fix a possible memory corruption in push locks
      CIFS: Fix a possible memory corruption during reconnect
      CIFS: Fix a possible double locking of mutex during reconnect

Rasmus Villemoes (1):
      cifs: use %16phN for formatting md5 sum

Sachin Prabhu (1):
      cifs_get_root shouldn't use path with tree name

Steve French (1):
      SMB3: parsing for new snapshot timestamp mount parm

 fs/cifs/cifsencrypt.c | 14 ++++++---
 fs/cifs/cifsfs.c      |  2 +-
 fs/cifs/cifsglob.h    |  8 +++++
 fs/cifs/cifsproto.h   |  6 +++-
 fs/cifs/connect.c     | 82 +++++++++++++++++++++++++++++++++++++++++-------
 fs/cifs/dir.c         |  4 +--
 fs/cifs/file.c        |  8 ++++-
 fs/cifs/ioctl.c       |  2 +-
 fs/cifs/link.c        |  9 ++----
 fs/cifs/smb2file.c    |  2 +-
 fs/cifs/smb2pdu.c     | 87 ++++++++++++++++++++++++++++++++++-----------------
 fs/cifs/smb2pdu.h     |  2 ++
 fs/cifs/smb2proto.h   |  1 +
 fs/cifs/smbencrypt.c  | 40 +++++------------------
 14 files changed, 177 insertions(+), 90 deletions(-)

On Sat, Dec 24, 2016 at 1:40 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Sat, Dec 24, 2016 at 8:53 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> They are available in the git repository at:
>>
>>   git://git.samba.org/sfrench/cifs-2.6.git for-next
>
> The diffstat does not match what I get. It looks like yours is truncated.
>
> The shortlog matches, so I think it's ok, but please check your scripting.
>
>              Linus



-- 
Thanks,

Steve
