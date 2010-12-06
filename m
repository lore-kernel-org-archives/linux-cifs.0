From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: linux-next: Tree for December 3 (cifs)
Date: Mon, 6 Dec 2010 09:40:33 -0600
Message-ID: <AANLkTimTFi6jji5wmnBTT25XYAXAhJYNY+YmqhW5McEC@mail.gmail.com>
References: <20101203130440.9f89dd31.sfr@canb.auug.org.au>
	<20101203094844.68f2bc40.randy.dunlap@oracle.com>
	<20101206070956.GA5570@elte.hu>
	<20101206073513.54ca2c71@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ingo Molnar <mingo@elte.hu>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Steve French <sfrench@samba.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-cifs@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101206073513.54ca2c71@tlielax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Dec 6, 2010 at 6:35 AM, Jeff Layton <jlayton@redhat.com> wrote:
> On Mon, 6 Dec 2010 08:09:56 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>> > On Fri, 3 Dec 2010 13:04:40 +1100 Stephen Rothwell wrote:
>> >
>> > > Hi all,
>> > >
>> > > Changes since 20101202:
>> >
>> >
>> > When CIFS_EXPERIMENTAL is not enabled:
>> >
>> > (.text+0xdf6c9): undefined reference to `get_cifs_acl'
>> >
>> > from fs/cifs/xattr.c:cifs_getxattr()
>> >
>> >
>> > CONFIG_CIFS=3Dy
>> > # CONFIG_CIFS_STATS is not set
>> > CONFIG_CIFS_WEAK_PW_HASH=3Dy
>> > # CONFIG_CIFS_UPCALL is not set
>> > CONFIG_CIFS_XATTR=3Dy
>> > CONFIG_CIFS_POSIX=3Dy
>> > # CONFIG_CIFS_DEBUG2 is not set
>> > # CONFIG_CIFS_DFS_UPCALL is not set
>> > CONFIG_CIFS_FSCACHE=3Dy
>> > CONFIG_CIFS_ACL=3Dy
>> > # CONFIG_CIFS_EXPERIMENTAL is not set
>>
>> And this build regression has been pushed upstream now, as of:
>>
>> =A0 =A08520eeaa1235: Merge git://git.kernel.org/pub/scm/linux/kernel=
/git/sfrench/cifs-2.6
>>
>> and it is triggering for me too:
>>
>> =A0 =A0fs/built-in.o: In function `cifs_getxattr':
>> =A0 =A0(.text+0xc518e): undefined reference to `get_cifs_acl'
>>
>> The regression got introduced by:
>>
>> =A0 =A0fbeba8bb16d7: cifs: Handle extended attribute name cifs_acl t=
o generate cifs acl blob (try #4)
>>
>> Which introduced the new CIFS_ACL option.
>>
>> Thanks,
>>
>> =A0 =A0 =A0 Ingo
>
> Yeah, looks like this new Kconfig option depends on some code that's
> under the (much-overloaded) CIFS_EXPERIMENTAL Kconfig option. I think
> this patch needs some rework. The simple fix would be to make it
> dependent on CIFS_EXPERIMENTAL, but that's rather icky since

Making CONFIG_CIFS_ACL dependent on CONFIG_CIFS_EXPERIMENTAL
works

 config CIFS_ACL
          bool "Provide CIFS ACL support (EXPERIMENTAL)"
-         depends on EXPERIMENTAL && CIFS_XATTR
+         depends on CIFS_EXPERIMENTAL && CIFS_XATTR
          help
            Allows to fetch CIFS/NTFS ACL from the server.  The DACL bl=
ob
            is handed over to the application/caller.

At the minimum function find_readable_file() and three functions
in cifssmb.c would not have to be in CIFS_EXPERIMENTAL.
And we would need to move some other cifs acl related functions
from under CIFS_ACL from CIFS_EXPERIMENTAL.

> CIFS_EXPERIMENTAL pulls in some rather broken stuff...
>
> --
> Jeff Layton <jlayton@redhat.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
