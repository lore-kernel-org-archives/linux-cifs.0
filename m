From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH 1/7] cifs: smbd: Make upper layer decide when to destroy
 the transport
Date: Tue, 8 May 2018 19:29:11 +0000
Message-ID: <MWHPR2101MB0729FCF022C6FD9CD221BA0BCE9A0@MWHPR2101MB0729.namprd21.prod.outlook.com>
References: <20180507222006.20781-1-longli@linuxonhyperv.com>
 <201805081127.wRLCfHId%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "kbuild-all@01.org" <kbuild-all@01.org>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
To: kbuild test robot <lkp@intel.com>,
        Long Li <longli@linuxonhyperv.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201805081127.wRLCfHId%fengguang.wu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> Subject: Re: [PATCH 1/7] cifs: smbd: Make upper layer decide when to
> destroy the transport
>=20
> Hi Long,
>=20
> Thank you for the patch! Yet something to improve:
>=20
> [auto build test ERROR on cifs/for-next] [also build test ERROR on v4.17-=
rc4
> next-20180507] [if your patch is applied to the wrong git tree, please dr=
op us
> a note to help improve the system]
>=20
> url:
> https://na01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithub
> .com%2F0day-ci%2Flinux%2Fcommits%2FLong-Li%2Fcifs-smbd-Make-upper-
> layer-decide-when-to-destroy-the-transport%2F20180508-
> 110150&data=3D02%7C01%7Clongli%40microsoft.com%7C8eeef6813ee14ded2
> dcc08d5b4a4113a%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C636
> 613539125415461&sdata=3D6EzmQWCVBK9EESOC3UQwrObR9AL9W5u660M4k
> bDvoJw%3D&reserved=3D0
> base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> config: i386-randconfig-x013-201818 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=3Di386
>=20
> All errors (new ones prefixed by >>):
>=20
>    fs//cifs/connect.c: In function 'cifs_reconnect':
> >> fs//cifs/connect.c:381:16: error: passing argument 1 of
> >> 'smbd_destroy' from incompatible pointer type
> >> [-Werror=3Dincompatible-pointer-types]
>       smbd_destroy(server);
>                    ^~~~~~

Thanks! I will send v2.

>    In file included from fs//cifs/connect.c:58:0:
>    fs//cifs/smbdirect.h:334:20: note: expected 'struct smbd_connection *'=
 but
> argument is of type 'struct TCP_Server_Info *'
>     static inline void smbd_destroy(struct smbd_connection *info) {}
>                        ^~~~~~~~~~~~
>    fs//cifs/connect.c: In function 'clean_demultiplex_info':
>    fs//cifs/connect.c:715:16: error: passing argument 1 of 'smbd_destroy'=
 from
> incompatible pointer type [-Werror=3Dincompatible-pointer-types]
>       smbd_destroy(server);
>                    ^~~~~~
>    In file included from fs//cifs/connect.c:58:0:
>    fs//cifs/smbdirect.h:334:20: note: expected 'struct smbd_connection *'=
 but
> argument is of type 'struct TCP_Server_Info *'
>     static inline void smbd_destroy(struct smbd_connection *info) {}
>                        ^~~~~~~~~~~~
>    Cyclomatic Complexity 5 include/linux/compiler.h:__read_once_size
>    Cyclomatic Complexity 5 include/linux/compiler.h:__write_once_size
>    Cyclomatic Complexity 1 include/linux/kasan-checks.h:kasan_check_read
>    Cyclomatic Complexity 1 include/linux/kasan-checks.h:kasan_check_write
>    Cyclomatic Complexity 2 arch/x86/include/asm/bitops.h:set_bit
>    Cyclomatic Complexity 2 arch/x86/include/asm/bitops.h:clear_bit
>    Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:test_and_set_bit
>    Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:constant_test_bi=
t
>    Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:variable_test_bi=
t
>    Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:fls
>    Cyclomatic Complexity 1
> include/uapi/linux/byteorder/little_endian.h:__le16_to_cpup
>    Cyclomatic Complexity 1 include/linux/log2.h:__ilog2_u32
>    Cyclomatic Complexity 1 include/linux/list.h:INIT_LIST_HEAD
>    Cyclomatic Complexity 1 include/linux/list.h:__list_add_valid
>    Cyclomatic Complexity 1 include/linux/list.h:__list_del_entry_valid
>    Cyclomatic Complexity 2 include/linux/list.h:__list_add
>    Cyclomatic Complexity 1 include/linux/list.h:list_add
>    Cyclomatic Complexity 1 include/linux/list.h:__list_del
>    Cyclomatic Complexity 2 include/linux/list.h:__list_del_entry
>    Cyclomatic Complexity 1 include/linux/list.h:list_del_init
>    Cyclomatic Complexity 1 include/linux/list.h:list_move
>    Cyclomatic Complexity 1 include/linux/list.h:list_empty
>    Cyclomatic Complexity 1 arch/x86/include/asm/current.h:get_current
>    Cyclomatic Complexity 1 include/linux/string.h:strnlen
>    Cyclomatic Complexity 4 include/linux/string.h:strlen
>    Cyclomatic Complexity 6 include/linux/string.h:strlcpy
>    Cyclomatic Complexity 3 include/linux/string.h:memset
>    Cyclomatic Complexity 4 include/linux/string.h:memcpy
>    Cyclomatic Complexity 2 include/linux/string.h:strcpy
>    Cyclomatic Complexity 1 include/asm-generic/getorder.h:__get_order
>    Cyclomatic Complexity 1 include/linux/err.h:ERR_PTR
>    Cyclomatic Complexity 1 include/linux/err.h:PTR_ERR
>    Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:arch_atomic_read
>    Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:arch_atomic_inc
>    Cyclomatic Complexity 1
> arch/x86/include/asm/atomic.h:arch_atomic_dec_and_test
>    Cyclomatic Complexity 1
> arch/x86/include/asm/atomic.h:arch_atomic_add_return
>    Cyclomatic Complexity 1
> arch/x86/include/asm/atomic.h:arch_atomic_sub_return
>    Cyclomatic Complexity 1 include/asm-generic/atomic-
> instrumented.h:atomic_read
>    Cyclomatic Complexity 1 include/asm-generic/atomic-
> instrumented.h:atomic_inc
>    Cyclomatic Complexity 1 include/asm-generic/atomic-
> instrumented.h:atomic_inc_return
>    Cyclomatic Complexity 1 include/asm-generic/atomic-
> instrumented.h:atomic_dec_return
>    Cyclomatic Complexity 1 include/asm-generic/atomic-
> instrumented.h:atomic_dec_and_test
>    Cyclomatic Complexity 5
> arch/x86/include/asm/preempt.h:__preempt_count_sub
>    Cyclomatic Complexity 1 include/linux/spinlock.h:spinlock_check
>    Cyclomatic Complexity 1 include/linux/spinlock.h:spin_lock
>    Cyclomatic Complexity 1 include/linux/spinlock.h:spin_unlock
>    Cyclomatic Complexity 1 include/linux/uidgid.h:__kuid_val
>    Cyclomatic Complexity 1 include/linux/uidgid.h:__kgid_val
>    Cyclomatic Complexity 1 include/linux/uidgid.h:uid_eq
>    Cyclomatic Complexity 1 include/linux/uidgid.h:gid_eq
>    Cyclomatic Complexity 1 include/linux/uidgid.h:uid_gt
>    Cyclomatic Complexity 1 include/linux/uidgid.h:uid_lt
>    Cyclomatic Complexity 1 include/linux/uidgid.h:uid_valid
>    Cyclomatic Complexity 1 include/linux/uidgid.h:gid_valid
>    Cyclomatic Complexity 1 include/linux/uidgid.h:make_kuid
>    Cyclomatic Complexity 1 include/linux/uidgid.h:make_kgid
>    Cyclomatic Complexity 1 include/linux/uidgid.h:from_kuid
>    Cyclomatic Complexity 1 include/linux/rbtree.h:rb_link_node
>    Cyclomatic Complexity 1
> include/linux/debug_locks.h:debug_check_no_locks_held
>    Cyclomatic Complexity 1 include/linux/workqueue.h:__init_work
>    Cyclomatic Complexity 1 include/linux/uio.h:iov_iter_count
>    Cyclomatic Complexity 1 include/linux/socket.h:msg_data_left
>    Cyclomatic Complexity 1 include/linux/sched.h:task_pid_nr
>    Cyclomatic Complexity 1 include/linux/sched.h:task_thread_info
>    Cyclomatic Complexity 1 include/linux/cred.h:current_user_ns
>    Cyclomatic Complexity 1 include/linux/kasan.h:kasan_kmalloc
>    Cyclomatic Complexity 28 include/linux/slab.h:kmalloc_index
>    Cyclomatic Complexity 1 include/linux/slab.h:kmem_cache_alloc_trace
>    Cyclomatic Complexity 1 include/linux/slab.h:kmalloc_order_trace
>    Cyclomatic Complexity 67 include/linux/slab.h:kmalloc_large
>    Cyclomatic Complexity 5 include/linux/slab.h:kmalloc
>    Cyclomatic Complexity 1 include/linux/slab.h:kzalloc
>    Cyclomatic Complexity 2 include/linux/ctype.h:__toupper
>    Cyclomatic Complexity 1 include/linux/utsname.h:utsname
>    Cyclomatic Complexity 1 include/net/net_namespace.h:get_net
>    Cyclomatic Complexity 1 include/net/net_namespace.h:put_net
>    Cyclomatic Complexity 1 include/net/net_namespace.h:net_eq
>    Cyclomatic Complexity 1 include/linux/module.h:__module_get
>    Cyclomatic Complexity 1 include/linux/module.h:module_put
>    Cyclomatic Complexity 1 include/keys/user-
> type.h:user_key_payload_locked
>    Cyclomatic Complexity 1 include/net/ipv6.h:ipv6_addr_equal
>    Cyclomatic Complexity 1
> include/linux/unaligned/access_ok.h:get_unaligned_le16
>    Cyclomatic Complexity 1 fs//cifs/cifspdu.h:BCC
>    Cyclomatic Complexity 1 fs//cifs/cifspdu.h:get_bcc
>    Cyclomatic Complexity 1 fs//cifs/cifsglob.h:set_credits
>    Cyclomatic Complexity 1 fs//cifs/cifsglob.h:get_next_mid
>=20
> vim +/smbd_destroy +381 fs//cifs/connect.c
>=20
>    312
>    313	static int ip_connect(struct TCP_Server_Info *server);
>    314	static int generic_ip_connect(struct TCP_Server_Info *server);
>    315	static void tlink_rb_insert(struct rb_root *root, struct tcon_link
> *new_tlink);
>    316	static void cifs_prune_tlinks(struct work_struct *work);
>    317	static int cifs_setup_volume_info(struct smb_vol *volume_info, cha=
r
> *mount_data,
>    318						const char *devname);
>    319
>    320	/*
>    321	 * cifs tcp session reconnection
>    322	 *
>    323	 * mark tcp session as reconnecting so temporarily locked
>    324	 * mark all smb sessions as reconnecting for tcp session
>    325	 * reconnect tcp session
>    326	 * wake up waiters on reconnection? - (not needed currently)
>    327	 */
>    328	int
>    329	cifs_reconnect(struct TCP_Server_Info *server)
>    330	{
>    331		int rc =3D 0;
>    332		struct list_head *tmp, *tmp2;
>    333		struct cifs_ses *ses;
>    334		struct cifs_tcon *tcon;
>    335		struct mid_q_entry *mid_entry;
>    336		struct list_head retry_list;
>    337
>    338		spin_lock(&GlobalMid_Lock);
>    339		if (server->tcpStatus =3D=3D CifsExiting) {
>    340			/* the demux thread will exit normally
>    341			next time through the loop */
>    342			spin_unlock(&GlobalMid_Lock);
>    343			return rc;
>    344		} else
>    345			server->tcpStatus =3D CifsNeedReconnect;
>    346		spin_unlock(&GlobalMid_Lock);
>    347		server->maxBuf =3D 0;
>    348		server->max_read =3D 0;
>    349
>    350		cifs_dbg(FYI, "Reconnecting tcp session\n");
>    351
>    352		/* before reconnecting the tcp session, mark the smb
> session (uid)
>    353			and the tid bad so they are not used until
> reconnected */
>    354		cifs_dbg(FYI, "%s: marking sessions and tcons for
> reconnect\n",
>    355			 __func__);
>    356		spin_lock(&cifs_tcp_ses_lock);
>    357		list_for_each(tmp, &server->smb_ses_list) {
>    358			ses =3D list_entry(tmp, struct cifs_ses, smb_ses_list);
>    359			ses->need_reconnect =3D true;
>    360			list_for_each(tmp2, &ses->tcon_list) {
>    361				tcon =3D list_entry(tmp2, struct cifs_tcon,
> tcon_list);
>    362				tcon->need_reconnect =3D true;
>    363			}
>    364			if (ses->tcon_ipc)
>    365				ses->tcon_ipc->need_reconnect =3D true;
>    366		}
>    367		spin_unlock(&cifs_tcp_ses_lock);
>    368
>    369		/* do not want to be sending data on a socket we are freeing
> */
>    370		cifs_dbg(FYI, "%s: tearing down socket\n", __func__);
>    371		mutex_lock(&server->srv_mutex);
>    372		if (server->ssocket) {
>    373			cifs_dbg(FYI, "State: 0x%x Flags: 0x%lx\n",
>    374				 server->ssocket->state, server->ssocket-
> >flags);
>    375			kernel_sock_shutdown(server->ssocket, SHUT_WR);
>    376			cifs_dbg(FYI, "Post shutdown state: 0x%x Flags:
> 0x%lx\n",
>    377				 server->ssocket->state, server->ssocket-
> >flags);
>    378			sock_release(server->ssocket);
>    379			server->ssocket =3D NULL;
>    380		} else if (cifs_rdma_enabled(server))
>  > 381			smbd_destroy(server);
>    382		server->sequence_number =3D 0;
>    383		server->session_estab =3D false;
>    384		kfree(server->session_key.response);
>    385		server->session_key.response =3D NULL;
>    386		server->session_key.len =3D 0;
>    387		server->lstrp =3D jiffies;
>    388
>    389		/* mark submitted MIDs for retry and issue callback */
>    390		INIT_LIST_HEAD(&retry_list);
>    391		cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
>    392		spin_lock(&GlobalMid_Lock);
>    393		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
>    394			mid_entry =3D list_entry(tmp, struct mid_q_entry,
> qhead);
>    395			if (mid_entry->mid_state =3D=3D
> MID_REQUEST_SUBMITTED)
>    396				mid_entry->mid_state =3D
> MID_RETRY_NEEDED;
>    397			list_move(&mid_entry->qhead, &retry_list);
>    398		}
>    399		spin_unlock(&GlobalMid_Lock);
>    400		mutex_unlock(&server->srv_mutex);
>    401
>    402		cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
>    403		list_for_each_safe(tmp, tmp2, &retry_list) {
>    404			mid_entry =3D list_entry(tmp, struct mid_q_entry,
> qhead);
>    405			list_del_init(&mid_entry->qhead);
>    406			mid_entry->callback(mid_entry);
>    407		}
>    408
>    409		do {
>    410			try_to_freeze();
>    411
>    412			/* we should try only the port we connected to
> before */
>    413			mutex_lock(&server->srv_mutex);
>    414			if (cifs_rdma_enabled(server))
>    415				rc =3D smbd_reconnect(server);
>    416			else
>    417				rc =3D generic_ip_connect(server);
>    418			if (rc) {
>    419				cifs_dbg(FYI, "reconnect error %d\n", rc);
>    420				mutex_unlock(&server->srv_mutex);
>    421				msleep(3000);
>    422			} else {
>    423				atomic_inc(&tcpSesReconnectCount);
>    424				spin_lock(&GlobalMid_Lock);
>    425				if (server->tcpStatus !=3D CifsExiting)
>    426					server->tcpStatus =3D
> CifsNeedNegotiate;
>    427				spin_unlock(&GlobalMid_Lock);
>    428				mutex_unlock(&server->srv_mutex);
>    429			}
>    430		} while (server->tcpStatus =3D=3D CifsNeedReconnect);
>    431
>    432		if (server->tcpStatus =3D=3D CifsNeedNegotiate)
>    433			mod_delayed_work(cifsiod_wq, &server->echo, 0);
>    434
>    435		return rc;
>    436	}
>    437
>=20
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Ce=
nter
> https://na01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flists.=
01
> .org%2Fpipermail%2Fkbuild-
> all&data=3D02%7C01%7Clongli%40microsoft.com%7C8eeef6813ee14ded2dcc08
> d5b4a4113a%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C63661353
> 9125415461&sdata=3DOrOmZ1yCHuTbOlK8c6oBG9FpUbjBcQR5nGGa%2BntzwL
> E%3D&reserved=3D0                   Intel Corporation
