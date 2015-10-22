From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 3/3] locks: cleanup posix_lock_inode_wait and
 flock_lock_inode_wait
Date: Fri, 23 Oct 2015 00:36:55 +0800
Message-ID: <201510230020.vZvDxsE7%fengguang.wu@intel.com>
References: <ded792d8fdcba562a1c74fd14fefcb387debc4b1.1445524157.git.bcodding@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Latchesar Ionkov <lucho@ionkov.net>, Christoph Hellwig <hch@infradead.org>,
 Trond Myklebust <trond.myklebust@primarydata.com>,
 "J. Bruce Fields" <bfields@fieldses.org>, Bob Peterson <rpeterso@redhat.com>,
 Jeff Layton <jlayton@poochiereds.net>, devel@driverdev.osuosl.org,
 linux-cifs@vger.kernel.org, Sage Weil <sage@redhat.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Steve French <sfrench@samba.org>,
 cluster-devel@redhat.com, Eric Van Hensbergen <ericvh@gmail.com>,
 Christine Caulfield <ccaulfie@redhat.com>,
 v9fs-developer@lists.sourceforge.net, Ilya Dryomov <idryomov@gmail.com>,
 fuse-devel@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>,
 Oleg Drokin <oleg.drokin@intel.com>, Julia Lawall <Julia.Lawall@lip6.fr>,
 David Teigland <teigland@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 ceph-devel@vger.kernel.org, Abdul Hussain <habdul@visteon.com>,
 Steven Whitehouse
To: Benjamin Coddington <bcodding@redhat.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <ded792d8fdcba562a1c74fd14fefcb387debc4b1.1445524157.git.bcodding@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-cifs.vger.kernel.org

Hi Benjamin,

[auto build test WARNING on jlayton/linux-next -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

url:    https://github.com/0day-ci/linux/commits/Benjamin-Coddington/locks-introduce-locks_lock_inode_wait/20151022-233848
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/locks.c:1176:5: sparse: symbol 'posix_lock_inode_wait' was not declared. Should it be static?
>> fs/locks.c:1863:5: sparse: symbol 'flock_lock_inode_wait' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
