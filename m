Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B335C432BE
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Aug 2021 00:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED2D760F4C
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Aug 2021 00:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236145AbhH3Ads (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 29 Aug 2021 20:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbhH3Adr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 29 Aug 2021 20:33:47 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6981DC061575;
        Sun, 29 Aug 2021 17:32:54 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id z2so27882648lft.1;
        Sun, 29 Aug 2021 17:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=wtNVwEUjsLgdYmUrZNBA5L7yC3BqiPCAP8llSBvZleY=;
        b=V5IAeCh5T4Ar/B2IvLD590lVaw+9NMQRtqtG7w9lqZAq0QcciIUavmbM9YjpabEqYU
         MkiyuLqnzh/FBDy3U437MijfnOLmcfVagThRo8Fj7OEduMVgXZYI8u7evekRV/IS34I3
         BM/uzh74ZqgB6drxIOTy6jI9P3YjBhUN8StdJ4hixcof6zMSaXGKlvXpEtBmNBPt/SOp
         kxAMlhPd+Ojm/J1fUxLaVYbXMa7MRVXHXxPvCmwlT79svZ0QK/ueCn83w7IjjmSnUH8I
         5/GkZbIVpv7ameg+yOOCsXhK2b6Mu3EsPRtvOmU0Mjxh77rZakjxl4xOwdoRQiDNlYty
         n9SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=wtNVwEUjsLgdYmUrZNBA5L7yC3BqiPCAP8llSBvZleY=;
        b=n92cXij6T6nPtOekbFeOA8RbPE8bhLI7IF/4CO8rvI2xEE0NLn8RMR2ilEd/Kyg2Xk
         sYhskom8WXbv1c9Q76f2WLcWJeQeO89aQSOUeaIw/70Qpq1JlcRJxk9jYmw4F/wic6VO
         zjjNXH9MmLpW3YVcmP2shY9ZKoRY56gODtN+JTXbeYzDM2cwHnO/Zko1j4jAnw2ENw/U
         eixQ2tyKDMhwYZC2UDRsiEdSllivDc4rAijHCbyDG4aSKrx4yQNN3cef7Pp8N2OaUXvR
         5F1Q4lh6bJOW6qo4Y91q6+hDYgOnsGVFFbD4aIm270RNDa0+7C0ai4RoME9O+oAtkgJb
         CT2w==
X-Gm-Message-State: AOAM533TWP1XB1rOXhalQoo8TDvtgLGjmqld7qlaNhzpCbDu4TNcOo8y
        9uuy9OYeX1WuRkwkL7JH5WMzvPK0wYLpZREa068=
X-Google-Smtp-Source: ABdhPJxxUupi5qLLHICiqqDCtcBr9mcMwvZqzPnmpKaif72sBB0f2o3I+YYUjkFLy3crkzMlpHLO00jo4/NT6i10JcI=
X-Received: by 2002:a05:6512:2201:: with SMTP id h1mr1499966lfu.307.1630283572556;
 Sun, 29 Aug 2021 17:32:52 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 29 Aug 2021 19:32:41 -0500
Message-ID: <CAH2r5msoKV7qAgoKipa+QNDJ+xR83YGuz+he+GH9sPTSzBMLHA@mail.gmail.com>
Subject: [GIT PULL] new smb3 kernel server (ksmbd)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Namjae Jeon <linkinjeon@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
6efb943b8616ec53a5e444193dccf1af9ad627b5:

  Linux 5.13-rc1 (2021-05-09 14:17:44 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/5.15-rc-first-ksmbd-merge

for you to fetch changes up to 7d5d8d7156892f82cf40b63228ce788248cc57a3:

  ksmbd: fix __write_overflow warning in ndr_read_string (2021-08-27
14:03:49 -0500)

----------------------------------------------------------------
Initial merge of kernel smb3 file server, ksmbd

The SMB family of protocols is the most widely deployed
network filesystem protocol, the default on Windows and Macs (and even
on many phones and tablets), with clients and servers on all major
operating systems, but lacked a kernel server for Linux. For many
cases the current userspace server choices were suboptimal
either due to memory footprint, performance or difficulty integrating
well with advanced Linux features.

ksmbd is a new kernel module which implements the server-side of the
SMB3 protocol.  The target is to provide optimized performance, GPLv2
SMB server,
better lease handling (distributed caching). The bigger goal is to add new
features more rapidly (e.g. RDMA aka "smbdirect", and recent encryption
and signing improvements to the protocol) which are easier to develop
on a smaller, more tightly optimized kernel server than for example in
Samba.  The Samba project is much broader in scope (tools, security services,
LDAP, Active Directory Domain Controller, and a cross platform file server
for a wider variety of purposes) but the user space file server portion
of Samba has proved hard to optimize for some Linux workloads, including
for smaller devices. This is not meant to replace Samba, but rather be
an extension to allow better optimizing for Linux, and will continue to
integrate well with Samba user space tools and libraries where appropriate.
Working with the Samba team we have already made sure that the configuration
files and xattrs are in a compatible format between the kernel and
user space server.

Various types of functional and regression tests are regularly run against it.
One example is the automated 'buildbot' regression tests which use the
Linux client to test against ksmbd (e.g.
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/56)
but other
test suites, including Samba's smbtorture functional test suite are also used
regularly.
----------------------------------------------------------------
Colin Ian King (4):
      cifsd: Fix a handful of spelling mistakes
      cifsd: remove redundant assignment to variable err
      ksmbd: fix kfree of uninitialized pointer oid
      ksmbd: Fix read on the uninitialized pointer sess

Dan Carpenter (8):
      cifsd: fix a precedence bug in parse_dacl()
      cifsd: fix a IS_ERR() vs NULL bug
      cifsd: Fix a use after free on error path
      cifsd: Fix an error code in smb2_read()
      cifsd: fix error handling in ksmbd_server_init()
      ksmbd: delete some stray tabs
      ksmbd: use kasprintf() in ksmbd_vfs_xattr_stream_name()
      ksmbd: fix an oops in error handling in smb2_open()

Gibeom Kim (1):
      cifsd: remove stale prototype and variables

Hyunchul Lee (33):
      cifsd: fix incorrect comments
      cifsd: remove calling d_path in error paths
      cifsd: handle unhashed dentry in ksmbd_vfs_mkdir
      cifsd: use file_inode() instead of d_inode()
      cifsd: remove useless error handling in ksmbd_vfs_read
      cifsd: re-implement ksmbd_vfs_kern_path
      cifsd: fix reference count decrement of unclaimed file in
__ksmbd_lookup_fd
      cifsd: decoding gss token using lib/asn1_decoder.c
      cifsd: lookup a file with LOOKUP_FOLLOW only if 'follow symlinks = yes'
      cifsd: enclose macro variables in parenthesis
      cifsd: make alignment match open parenthesis
      cifsd: fix possible compile error for asn1.c
      cifsd: append ksmbd prefix into names for asn1 decoder
      ksmbd: factor out a ksmbd_vfs_lock_parent helper
      ksmbd: set MAY_* flags together with open flags
      ksmbd: remove macros in transport_ipc.c
      ksmbd: replace BUFFER_NR_PAGES with inline function
      ksmbd: replace KSMBD_ALIGN with kernel ALIGN macro
      ksmbd: replace PAYLOAD_HEAD with inline function
      ksmbd: remove getting worker state macros
      ksmbd: remove and replace macros with inline functions in smb_common.h
      ksmbd: replace struct dentry with struct path in some function's arguments
      ksmbd: add user namespace support
      ksmbd: call mnt_user_ns once in a function
      ksmbd: fix the running request count decrement
      ksmbd: free ksmbd_lock when file is closed
      ksmbd: uninterruptible wait for a file being unlocked
      ksmbd: make smb2_find_context_vals return NULL if not found
      ksmbd: handle error cases first in smb2_create_sd_buffers
      ksmbd: set RDMA capability for FSCTL_QUERY_NETWORK_INTERFACE_INFO
      ksmbd: fix an error message in ksmbd_conn_trasnport_init
      ksmbd: fix -Wstringop-truncation warnings
      ksmbd: smbd: fix kernel oops during server shutdown

Marios Makassikis (13):
      cifsd: Remove smb2_put_name()
      cifsd: Fix potential null-ptr-deref in smb2_open()
      cifsd: Update access check in
set_file_allocation_info/set_end_of_file_info
      cifsd: Remove is_attributes_write_allowed() wrapper
      cifsd: Call smb2_set_err_rsp() in smb2_read/smb2_write error path
      cifsd: Handle ksmbd_session_rpc_open() failure in create_smb2_pipe()
      cifsd: Update out_buf_len in smb2_populate_readdir_entry()
      cifsd: Fix potential null-ptr-deref in destroy_previous_session()
      cifsd: Do not use 0 or 0xFFFFFFFF for TreeID
      ksmbd: Relax credit_charge check in smb2_validate_credit_charge()
      ksmbd: Fix potential memory leak in tcp_destroy_socket()
      ksmbd: Return STATUS_OBJECT_PATH_NOT_FOUND if smb2_creat() returns ENOENT
      ksmbd: Fix multi-protocol negotiation

Mauro Carvalho Chehab (1):
      doc: cifsd: change the reference to configuration.txt

Muhammad Usama Anjum (2):
      cifsd: fix memory leak when loop ends
      cifsd: use kfree to free memory allocated by kmalloc or kzalloc

Namjae Jeon (145):
      cifsd: add server handler for central processing and tranport layers
      cifsd: add server-side procedures for SMB3
      cifsd: add file operations
      cifsd: add Kconfig and Makefile
      MAINTAINERS: add cifsd kernel server
      cifsd: fix WARNING: Title overline too short
      cifsd: fix WARNING: document isn't included in any toctree
      cifsd: fix WARNING: unmet direct dependencies detected for CRYPTO_ARC4
      cifsd: fix static checker warning from smb_direct_post_send_data()
      cifsd: fix static checker warning from smb_check_perm_dacl()
      cifsd: update cifsd.rst document
      cifsd: add index.rst in cifs documentation
      cifsd: fix warning: variable 'total_ace_size' and
'posix_ccontext' set but not used
      cifsd: Pass string length parameter to match_pattern()
      cifsd: fix build warnings from cifsd.rst
      cifsd: remove unneeded macros
      cifsd: fix wrong use of rw semaphore in __session_create()
      cifsd: use kmalloc() for small allocations
      cifsd: add the check to work file lock and rename behaviors like
Windows unless POSIX extensions are negotiated
      cifsd: fix error return code in ksmbd_vfs_remove_file()
      cifsd: clean-up codes using chechpatch.pl --strict
      cifsd: merge time_wrappers.h into smb_common.h
      cifsd: fix wrong prototype in comment
      cifsd: fix implicit declaration of function 'groups_alloc'
      cifsd: fix implicit declaration of function 'locks_alloc_lock'
      cifsd: remove smack inherit leftovers
      cifsd: use xarray instead of linked list for tree connect list
      cifsd: remove wrappers of kvmalloc/kvfree
      cifsd: prevent a integer overflow in wm_alloc()
      cifsd: declare ida statically
      cifsd: add the check if parent is stable by unexpected rename
      cifsd: get parent dentry from child in ksmbd_vfs_remove_file()
      cifsd: remove unused smberr.h
      cifsd: remove unused nterr.c file
      cifsd: move nt time functions to misc.c
      cifsd: use d_inode()
      cifsd: remove the dead code of unimplemented durable handle
      cifsd: add ksmbd/nfsd interoperability to feature table
      cifsd: add support for AES256 encryption
      cifsd: fix invalid memory access in smb2_write()
      cifsd: fix WARNING: Possible unnecessary 'out of memory' message
      cifsd: fix WARNING: Too many leading tabs
      cifsd: fix build break from asn1
      cifsd: fix xfstests generic/504 test failure
      cifsd: add support for FSCTL_DUPLICATE_EXTENTS_TO_FILE
      cifsd: add goto fail in asn1_oid_decode()
      cifsd: use memcmp instead of for loop check in oid_eq()
      cifsd: add goto fail in neg_token_init_mech_type()
      cifsd: move fips_enabled check before the str_to_key()
      cifsd: just return smbhash() instead of using rc return value
      cifsd: move ret check before the out label
      cifsd: simplify error handling in ksmbd_auth_ntlm()
      cifsd: remove unneeded type casting
      cifsd: set error return value for memcmp() difference
      cifsd: return zero in always success case
      cifsd: never return 1 on failure
      cifsd: add the check if nvec is zero
      cifsd: len can never be negative in ksmbd_init_sg()
      cifsd: remove unneeded initialization of rc variable in
ksmbd_crypt_message()
      cifsd: fix wrong return value in ksmbd_crypt_message()
      cifsd: change success handling to failure handling
      cifsd: add default case in switch statment in alloc_shash_desc()
      cifsd: call kzalloc() directly instead of wrapper
      cifsd: simplify error handling in ksmbd_gen_preauth_integrity_hash()
      cifsd: return -ENOMEM about error from ksmbd_crypto_ctx_find_xxx calls
      cifsd: alignment match open parenthesis
      cifsd: add the check to prevent potential overflow with
smb_strtoUTF16() and UNICODE_LEN()
      cifsd: braces {} should be used on all arms of this statement
      cifsd: spaces preferred around that '/'
      cifsd: don't use multiple blank lines
      cifsd: No space is necessary after a cast
      cifsd: Blank lines aren't necessary after an open brace '{'
      cifsd: Alignment should match open parenthesis
      cifsd: remove unnecessary parentheses around
      cifsd: Prefer kernel type 'u16' over 'uint16_t'
      cifsd: fix Control flow issues in ksmbd_build_ntlmssp_challenge_blob()
      cifsd: fix potential read overflow in ksmbd_vfs_stream_read()
      cifsd: fix additional warnings from checkpatch.pl --strict
      cifsd: fix list_add double add BUG_ON trap in setup_async_work()
      cifsd: set epoch in smb2_lease_break response
      ksmbd: add support for SMB3 multichannel
      ksmbd: remove cache read/trans buffer support
      ksmbd: initialize variables on the declaration
      ksmbd: remove ksmbd_vfs_copy_file_range
      ksmbd: use list_for_each_entry instead of list_for_each
      ksmbd: use goto instead of duplicating the resoure cleanup in
ksmbd_open_fd
      ksmbd: fix overly long line
      ksmbd: remove unneeded FIXME comment
      ksmbd: remove ____ksmbd_align in ksmbd_server.h
      ksmbd: replace KSMBD_SHARE_CONFIG_PATH with inline function
      ksmbd: remove ksmbd_err/info
      ksmbd: opencode to avoid trivial wrappers
      ksmbd: factor out a ksmbd_validate_entry_in_use helper from
__ksmbd_vfs_rename
      ksmbd: opencode posix acl functions instead of wrappers
      ksmbd: change stream type macro to enumeration
      ksmbd: use f_bsize instead of q->limits.logical_block_size
      ksmbd: remove unneeded NULL check in the list iterator
      ksmbd: use f_bsize in FS_SECTOR_SIZE_INFORMATION
      ksmbd: move fs/cifsd to fs/ksmbd
      MAINTAINERS: rename cifsd to ksmbd
      ksmbd: replace SMB_DIRECT_TRANS macro with inline function
      ksmbd: replace request and respone buffer macro with inline functions
      ksmbd: allow PROTECTED_DACL_SECINFO and UNPROTECTED_DACL_SECINFO
addition information in smb2 set info security
      ksmbd: fix dentry racy with rename()
      ksmbd: opencode to remove FP_INODE macro
      ksmbd: use ksmbd_vfs_lock_parent to get stable parent dentry
      ksmbd: opencode to remove ATTR_FP macro
      ksmbd: remove SMB1 oplock level macros
      ksmbd: change ACE types to enumeration
      ksmbd: change sid types to enumeration
      ksmbd: change server state type macro to enumeration
      ksmbd: change server config string index to enumeration
      ksmbd: reorder and document on-disk and netlink structures in headers
      ksmbd: fix kernel oops in ksmbd_rpc_ioctl/rap()
      ksmbd: remove unneeded NULL check in for_each_netdev
      ksmbd: fix read on the uninitialized send_ctx
      ksmbd: fix memory leak smb2_populate_readdir_entry()
      ksmbd: fix memory leak in smb_inherit_dacl()
      ksmbd: change data type of volatile/persistent id to u64
      ksmbd: remove unneeded check_context_err
      ksmbd: fix memory leak in ksmbd_vfs_get_sd_xattr()
      ksmbd: fix unused err value in smb2_lock
      ksmbd: fix typo in comment
      ksmbd: fix wrong compression context size
      ksmbd: fix wrong error status return on session setup
      ksmbd: set STATUS_INVALID_PARAMETER error status if credit
charge is invalid
      ksmbd: move credit charge verification over smb2 request size verification
      ksmbd: fix typo of MS-SMBD
      ksmbd: add negotiate context verification
      ksmbd: add support for negotiating signing algorithm
      ksmbd: don't set RSS capable in FSCTL_QUERY_NETWORK_INTERFACE_INFO
      ksmbd: use channel signingkey for binding SMB2 session setup
      ksmbd: fix missing error code in smb2_lock
      ksmbd: add ipv6_addr_v4mapped check to know if connection from
client is ipv4
      ksmbd: change int data type to boolean
      ksmbd: update the comment for smb2_get_ksmbd_tcon()
      ksmbd: use proper errno instead of -1 in smb2_get_ksmbd_tcon()
      ksmbd: remove select FS_POSIX_ACL in Kconfig
      ksmbd: update SMB3 multi-channel support in ksmbd.rst
      MAINTAINERS: add git adddress of ksmbd
      ksmbd: don't set FILE DELETE and FILE_DELETE_CHILD in access
mask by default
      ksmbd: fix permission check issue on chown and chmod
      MAINTAINERS: ksmbd: update my email address
      MAINTAINERS: ksmbd: add cifs_common directory to ksmbd entry
      ksmbd: fix __write_overflow warning in ndr_read_string

Sebastian Gottschall (1):
      cifsd: Fix regression in smb2_get_info

Sergey Senozhatsky (1):
      cifsd: remove unneeded FIXME comments

Stephen Rothwell (1):
      cifsd: uniquify extract_sharename()

Steve French (22):
      Merge pull request #46 from namjaejeon/cifsd-for-next
      Merge pull request #47 from namjaejeon/cifsd-for-next
      Merge pull request #48 from namjaejeon/cifsd-for-next
      Merge pull request #49 from namjaejeon/cifsd-for-next
      Merge pull request #50 from namjaejeon/cifsd-for-next
      Merge pull request #51 from namjaejeon/cifsd-for-next
      Merge pull request #52 from namjaejeon/cifsd-for-next
      Merge pull request #53 from namjaejeon/cifsd-for-next
      Merge pull request #54 from namjaejeon/cifsd-for-next
      Merge pull request #55 from namjaejeon/cifsd-for-next
      Merge pull request #56 from namjaejeon/cifsd-for-next
      Merge pull request #57 from namjaejeon/cifsd-for-next
      Merge pull request #58 from namjaejeon/cifsd-for-next
      Merge pull request #59 from namjaejeon/cifsd-for-next
      Merge pull request #60 from namjaejeon/cifsd-for-next
      Merge pull request #61 from namjaejeon/cifsd-for-next
      Merge pull request #62 from namjaejeon/cifsd-for-next
      Merge pull request #63 from namjaejeon/cifsd-for-next
      Merge pull request #64 from namjaejeon/cifsd-for-next
      Merge pull request #66 from namjaejeon/cifsd-for-next
      Merge pull request #68 from namjaejeon/cifsd-for-next
      Merge pull request #69 from namjaejeon/cifsd-for-next

Tian Tao (1):
      cifsd: remove unused including <linux/version.h>

Wan Jiabing (1):
      cifsd: remove duplicated argument

Wei Yongjun (1):
      cifsd: fix build error without CONFIG_OID_REGISTRY

Yang Yingliang (3):
      cifsd: fix memleak in ksmbd_vfs_stream_write()
      cifsd: fix memleak in ksmbd_vfs_stream_read()
      cifsd: check return value of ksmbd_vfs_getcasexattr() correctly

Zhang Xiaoxu (1):
      cifsd: Select SG_POOL for SMB_SERVER_SMBDIRECT

kernel test robot (2):
      cifsd: fix memdup.cocci warnings
      cifsd: fix boolreturn.cocci warnings

 Documentation/filesystems/cifs/index.rst |   10 +
 Documentation/filesystems/cifs/ksmbd.rst |  165 +
 Documentation/filesystems/index.rst      |    2 +-
 MAINTAINERS                              |   13 +-
 fs/Kconfig                               |    1 +
 fs/Makefile                              |    1 +
 fs/ksmbd/Kconfig                         |   68 +
 fs/ksmbd/Makefile                        |   20 +
 fs/ksmbd/asn1.c                          |  343 ++
 fs/ksmbd/asn1.h                          |   21 +
 fs/ksmbd/auth.c                          | 1364 +++++
 fs/ksmbd/auth.h                          |   67 +
 fs/ksmbd/connection.c                    |  413 ++
 fs/ksmbd/connection.h                    |  213 +
 fs/ksmbd/crypto_ctx.c                    |  282 +
 fs/ksmbd/crypto_ctx.h                    |   74 +
 fs/ksmbd/glob.h                          |   49 +
 fs/ksmbd/ksmbd_netlink.h                 |  395 ++
 fs/ksmbd/ksmbd_spnego_negtokeninit.asn1  |   31 +
 fs/ksmbd/ksmbd_spnego_negtokentarg.asn1  |   19 +
 fs/ksmbd/ksmbd_work.c                    |   80 +
 fs/ksmbd/ksmbd_work.h                    |  117 +
 fs/ksmbd/mgmt/ksmbd_ida.c                |   46 +
 fs/ksmbd/mgmt/ksmbd_ida.h                |   34 +
 fs/ksmbd/mgmt/share_config.c             |  238 +
 fs/ksmbd/mgmt/share_config.h             |   81 +
 fs/ksmbd/mgmt/tree_connect.c             |  121 +
 fs/ksmbd/mgmt/tree_connect.h             |   56 +
 fs/ksmbd/mgmt/user_config.c              |   69 +
 fs/ksmbd/mgmt/user_config.h              |   66 +
 fs/ksmbd/mgmt/user_session.c             |  369 ++
 fs/ksmbd/mgmt/user_session.h             |  106 +
 fs/ksmbd/misc.c                          |  338 ++
 fs/ksmbd/misc.h                          |   35 +
 fs/ksmbd/ndr.c                           |  345 ++
 fs/ksmbd/ndr.h                           |   22 +
 fs/ksmbd/nterr.h                         |  543 ++
 fs/ksmbd/ntlmssp.h                       |  169 +
 fs/ksmbd/oplock.c                        | 1709 ++++++
 fs/ksmbd/oplock.h                        |  131 +
 fs/ksmbd/server.c                        |  633 +++
 fs/ksmbd/server.h                        |   70 +
 fs/ksmbd/smb2misc.c                      |  438 ++
 fs/ksmbd/smb2ops.c                       |  312 ++
 fs/ksmbd/smb2pdu.c                       | 8373 ++++++++++++++++++++++++++++++
 fs/ksmbd/smb2pdu.h                       | 1698 ++++++
 fs/ksmbd/smb_common.c                    |  674 +++
 fs/ksmbd/smb_common.h                    |  542 ++
 fs/ksmbd/smbacl.c                        | 1366 +++++
 fs/ksmbd/smbacl.h                        |  212 +
 fs/ksmbd/smbfsctl.h                      |   91 +
 fs/ksmbd/smbstatus.h                     | 1822 +++++++
 fs/ksmbd/transport_ipc.c                 |  874 ++++
 fs/ksmbd/transport_ipc.h                 |   47 +
 fs/ksmbd/transport_rdma.c                | 2058 ++++++++
 fs/ksmbd/transport_rdma.h                |   63 +
 fs/ksmbd/transport_tcp.c                 |  618 +++
 fs/ksmbd/transport_tcp.h                 |   13 +
 fs/ksmbd/unicode.c                       |  384 ++
 fs/ksmbd/unicode.h                       |  357 ++
 fs/ksmbd/uniupr.h                        |  268 +
 fs/ksmbd/vfs.c                           | 1895 +++++++
 fs/ksmbd/vfs.h                           |  197 +
 fs/ksmbd/vfs_cache.c                     |  725 +++
 fs/ksmbd/vfs_cache.h                     |  178 +
 fs/ksmbd/xattr.h                         |  122 +
 66 files changed, 32254 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/filesystems/cifs/index.rst
 create mode 100644 Documentation/filesystems/cifs/ksmbd.rst
 create mode 100644 fs/ksmbd/Kconfig
 create mode 100644 fs/ksmbd/Makefile
 create mode 100644 fs/ksmbd/asn1.c
 create mode 100644 fs/ksmbd/asn1.h
 create mode 100644 fs/ksmbd/auth.c
 create mode 100644 fs/ksmbd/auth.h
 create mode 100644 fs/ksmbd/connection.c
 create mode 100644 fs/ksmbd/connection.h
 create mode 100644 fs/ksmbd/crypto_ctx.c
 create mode 100644 fs/ksmbd/crypto_ctx.h
 create mode 100644 fs/ksmbd/glob.h
 create mode 100644 fs/ksmbd/ksmbd_netlink.h
 create mode 100644 fs/ksmbd/ksmbd_spnego_negtokeninit.asn1
 create mode 100644 fs/ksmbd/ksmbd_spnego_negtokentarg.asn1
 create mode 100644 fs/ksmbd/ksmbd_work.c
 create mode 100644 fs/ksmbd/ksmbd_work.h
 create mode 100644 fs/ksmbd/mgmt/ksmbd_ida.c
 create mode 100644 fs/ksmbd/mgmt/ksmbd_ida.h
 create mode 100644 fs/ksmbd/mgmt/share_config.c
 create mode 100644 fs/ksmbd/mgmt/share_config.h
 create mode 100644 fs/ksmbd/mgmt/tree_connect.c
 create mode 100644 fs/ksmbd/mgmt/tree_connect.h
 create mode 100644 fs/ksmbd/mgmt/user_config.c
 create mode 100644 fs/ksmbd/mgmt/user_config.h
 create mode 100644 fs/ksmbd/mgmt/user_session.c
 create mode 100644 fs/ksmbd/mgmt/user_session.h
 create mode 100644 fs/ksmbd/misc.c
 create mode 100644 fs/ksmbd/misc.h
 create mode 100644 fs/ksmbd/ndr.c
 create mode 100644 fs/ksmbd/ndr.h
 create mode 100644 fs/ksmbd/nterr.h
 create mode 100644 fs/ksmbd/ntlmssp.h
 create mode 100644 fs/ksmbd/oplock.c
 create mode 100644 fs/ksmbd/oplock.h
 create mode 100644 fs/ksmbd/server.c
 create mode 100644 fs/ksmbd/server.h
 create mode 100644 fs/ksmbd/smb2misc.c
 create mode 100644 fs/ksmbd/smb2ops.c
 create mode 100644 fs/ksmbd/smb2pdu.c
 create mode 100644 fs/ksmbd/smb2pdu.h
 create mode 100644 fs/ksmbd/smb_common.c
 create mode 100644 fs/ksmbd/smb_common.h
 create mode 100644 fs/ksmbd/smbacl.c
 create mode 100644 fs/ksmbd/smbacl.h
 create mode 100644 fs/ksmbd/smbfsctl.h
 create mode 100644 fs/ksmbd/smbstatus.h
 create mode 100644 fs/ksmbd/transport_ipc.c
 create mode 100644 fs/ksmbd/transport_ipc.h
 create mode 100644 fs/ksmbd/transport_rdma.c
 create mode 100644 fs/ksmbd/transport_rdma.h
 create mode 100644 fs/ksmbd/transport_tcp.c
 create mode 100644 fs/ksmbd/transport_tcp.h
 create mode 100644 fs/ksmbd/unicode.c
 create mode 100644 fs/ksmbd/unicode.h
 create mode 100644 fs/ksmbd/uniupr.h
 create mode 100644 fs/ksmbd/vfs.c
 create mode 100644 fs/ksmbd/vfs.h
 create mode 100644 fs/ksmbd/vfs_cache.c
 create mode 100644 fs/ksmbd/vfs_cache.h
 create mode 100644 fs/ksmbd/xattr.h

-- 
Thanks,

Steve
