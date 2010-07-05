From: Suresh Jayaraman <sjayaraman@suse.de>
Subject: [PATCH 00/09] cifs: local caching support using
	FS-Cache
Date: Mon,  5 Jul 2010 18:11:03 +0530
Message-ID: <1278333663-30464-1-git-send-email-sjayaraman@suse.de>
References: <Yes>
Reply-To: Linux filesystem caching discussion list <linux-cachefs@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-cachefs@redhat.com
To: Steve French <smfrench@gmail.com>
Return-path: <linux-cachefs-bounces@redhat.com>
In-Reply-To: <Yes>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-cachefs>,
	<mailto:linux-cachefs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-cachefs>
List-Post: <mailto:linux-cachefs@redhat.com>
List-Help: <mailto:linux-cachefs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-cachefs>,
	<mailto:linux-cachefs-request@redhat.com?subject=subscribe>
Sender: linux-cachefs-bounces@redhat.com
Errors-To: linux-cachefs-bounces@redhat.com
List-Id: linux-cifs.vger.kernel.org

This patchset is a second try at adding persistent, local caching facility for
CIFS using the FS-Cache interface.

The cache index hierarchy which is mainly used to locate a file object or
discard a certain subset of the files cached, currently has three levels:
	- Server
	- Share 
	- File

The server index object is keyed by IPaddress of the server, socket family
and the port. The superblock index object is keyed by the sharename and the
inode object is keyed by the UniqueId. The cache coherency is ensured by
checking the LastWriteTime, LastChangeTime and end of file (eof) reported by
the server.

Changes since last post:
-------------------------
   - fix a bug during registration with FS-Cache
   - fix a bug while storing pages to the cache. The earlier set needed an rsize
     of 4096 to make caching working properly due to this bug.
   - server index key uses {IPaddress,family,port} tuple instead of servername
   - root dir of the share is validated by UniqueId/IndexNumber. Almost all
     servers seem to provide one of them and it's unique.
   - we now check LastWriteTime, LastChangeTime and eof of server for data
     coherency. CreateTime could be considered once some of related development
     effort advances
   - dropped the patch to guard cifsglob.h against multiple inclusion as it
     has been included in Jeff Layton's tree
   - some cleanups

To try these patches:

   - apply this patchset in order
   - mount the share, for e.g. mount -t cifs //server/share -o user=guest
   - try copying a huge file (say few hundred MBs) from mount point to local
     filesystem (during the first time, the cache will be initialized)
   - when you copy the second time, it should be read from the local cache (you
     could unmount and remount to reduce the page cache impact).


Known issues
--------------
   - when the 'noserverino' mount option is used, the client generates
     UniqueId itself rather than using the UniqueId from the server. As
     we use UniqueId to ensure that the root directory did not change
     under the hood, we won't be able to benefit from the cache.
   - the cache coherency check may not be reliable always as some
     CIFS servers are known not to update mtime until the filehandle is closed.

Suresh Jayaraman (09):
  cifs: add kernel config option for CIFS Client caching support
  cifs: register CIFS for caching
  cifs: define server-level cache index objects and register them with FS-Cache
  cifs: define superblock-level cache index objects and register them
  cifs: define inode-level cache object and register them
  cifs: FS-Cache page management
  cifs: store pages into local cache
  cifs: read pages from FS-Cache
  cifs: add mount option to enable local caching


 Kconfig      |    9 +
 Makefile     |    2 
 cache.c      |  331 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cifs_fs_sb.h |    1 
 cifsfs.c     |   15 ++
 cifsglob.h   |   10 +
 connect.c    |   16 ++
 file.c       |   50 ++++++++
 fscache.c    |  236 ++++++++++++++++++++++++++++++++++++++++++
 fscache.h    |  136 ++++++++++++++++++++++++
 inode.c      |    7 +
 11 files changed, 813 insertions(+)
