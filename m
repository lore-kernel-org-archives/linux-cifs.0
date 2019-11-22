Return-Path: <SRS0=i0zP=ZO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B2BC432C0
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 10:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE14D2070E
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 10:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKVKJu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Nov 2019 05:09:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:26388 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbfKVKJu (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 22 Nov 2019 05:09:50 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 02:09:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,229,1571727600"; 
   d="gz'50?scan'50,208,50";a="210389049"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 22 Nov 2019 02:09:46 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iY5sn-0003Sm-JL; Fri, 22 Nov 2019 18:09:45 +0800
Date:   Fri, 22 Nov 2019 18:09:21 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     kbuild-all@lists.01.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 33/35] fs/cifs/cifs_debug.c:402:44: warning: format
 '%lu' expects argument of type 'long unsigned int', but argument 3 has type
 'size_t {aka unsigned int}'
Message-ID: <201911221816.2rx7V48j%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wcydptwka6obxnng"
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--wcydptwka6obxnng
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   85c48cf275b0279d13f42e61904ffca1e4da0a50
commit: ac204b8b2b598cb64db24832aa0df347c6480616 [33/35] cifs: dump channel info in DebugData
config: parisc-defconfig (attached as .config)
compiler: hppa-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout ac204b8b2b598cb64db24832aa0df347c6480616
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=parisc 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   fs/cifs/cifs_debug.c: In function 'cifs_dump_channel':
   fs/cifs/cifs_debug.c:141:25: error: 'struct TCP_Server_Info' has no member named 'in_send'
         atomic_read(&server->in_send),
                            ^~
   fs/cifs/cifs_debug.c:142:25: error: 'struct TCP_Server_Info' has no member named 'num_waiters'
         atomic_read(&server->num_waiters));
                            ^~
   fs/cifs/cifs_debug.c: In function 'cifs_debug_data_proc_show':
>> fs/cifs/cifs_debug.c:402:44: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t {aka unsigned int}' [-Wformat=]
        seq_printf(m, "\n\n\tExtra Channels: %lu\n",
                                             ~~^
                                             %u
            ses->chan_count-1);
            ~~~~~~~~~~~~~~~~~                   

vim +402 fs/cifs/cifs_debug.c

   215	
   216	static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
   217	{
   218		struct list_head *tmp1, *tmp2, *tmp3;
   219		struct mid_q_entry *mid_entry;
   220		struct TCP_Server_Info *server;
   221		struct cifs_ses *ses;
   222		struct cifs_tcon *tcon;
   223		int i, j;
   224	
   225		seq_puts(m,
   226			    "Display Internal CIFS Data Structures for Debugging\n"
   227			    "---------------------------------------------------\n");
   228		seq_printf(m, "CIFS Version %s\n", CIFS_VERSION);
   229		seq_printf(m, "Features:");
   230	#ifdef CONFIG_CIFS_DFS_UPCALL
   231		seq_printf(m, " DFS");
   232	#endif
   233	#ifdef CONFIG_CIFS_FSCACHE
   234		seq_printf(m, ",FSCACHE");
   235	#endif
   236	#ifdef CONFIG_CIFS_SMB_DIRECT
   237		seq_printf(m, ",SMB_DIRECT");
   238	#endif
   239	#ifdef CONFIG_CIFS_STATS2
   240		seq_printf(m, ",STATS2");
   241	#else
   242		seq_printf(m, ",STATS");
   243	#endif
   244	#ifdef CONFIG_CIFS_DEBUG2
   245		seq_printf(m, ",DEBUG2");
   246	#elif defined(CONFIG_CIFS_DEBUG)
   247		seq_printf(m, ",DEBUG");
   248	#endif
   249	#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
   250		seq_printf(m, ",ALLOW_INSECURE_LEGACY");
   251	#endif
   252	#ifdef CONFIG_CIFS_WEAK_PW_HASH
   253		seq_printf(m, ",WEAK_PW_HASH");
   254	#endif
   255	#ifdef CONFIG_CIFS_POSIX
   256		seq_printf(m, ",CIFS_POSIX");
   257	#endif
   258	#ifdef CONFIG_CIFS_UPCALL
   259		seq_printf(m, ",UPCALL(SPNEGO)");
   260	#endif
   261	#ifdef CONFIG_CIFS_XATTR
   262		seq_printf(m, ",XATTR");
   263	#endif
   264		seq_printf(m, ",ACL");
   265		seq_putc(m, '\n');
   266		seq_printf(m, "CIFSMaxBufSize: %d\n", CIFSMaxBufSize);
   267		seq_printf(m, "Active VFS Requests: %d\n", GlobalTotalActiveXid);
   268		seq_printf(m, "Servers:");
   269	
   270		i = 0;
   271		spin_lock(&cifs_tcp_ses_lock);
   272		list_for_each(tmp1, &cifs_tcp_ses_list) {
   273			server = list_entry(tmp1, struct TCP_Server_Info,
   274					    tcp_ses_list);
   275	
   276	#ifdef CONFIG_CIFS_SMB_DIRECT
   277			if (!server->rdma)
   278				goto skip_rdma;
   279	
   280			if (!server->smbd_conn) {
   281				seq_printf(m, "\nSMBDirect transport not available");
   282				goto skip_rdma;
   283			}
   284	
   285			seq_printf(m, "\nSMBDirect (in hex) protocol version: %x "
   286				"transport status: %x",
   287				server->smbd_conn->protocol,
   288				server->smbd_conn->transport_status);
   289			seq_printf(m, "\nConn receive_credit_max: %x "
   290				"send_credit_target: %x max_send_size: %x",
   291				server->smbd_conn->receive_credit_max,
   292				server->smbd_conn->send_credit_target,
   293				server->smbd_conn->max_send_size);
   294			seq_printf(m, "\nConn max_fragmented_recv_size: %x "
   295				"max_fragmented_send_size: %x max_receive_size:%x",
   296				server->smbd_conn->max_fragmented_recv_size,
   297				server->smbd_conn->max_fragmented_send_size,
   298				server->smbd_conn->max_receive_size);
   299			seq_printf(m, "\nConn keep_alive_interval: %x "
   300				"max_readwrite_size: %x rdma_readwrite_threshold: %x",
   301				server->smbd_conn->keep_alive_interval,
   302				server->smbd_conn->max_readwrite_size,
   303				server->smbd_conn->rdma_readwrite_threshold);
   304			seq_printf(m, "\nDebug count_get_receive_buffer: %x "
   305				"count_put_receive_buffer: %x count_send_empty: %x",
   306				server->smbd_conn->count_get_receive_buffer,
   307				server->smbd_conn->count_put_receive_buffer,
   308				server->smbd_conn->count_send_empty);
   309			seq_printf(m, "\nRead Queue count_reassembly_queue: %x "
   310				"count_enqueue_reassembly_queue: %x "
   311				"count_dequeue_reassembly_queue: %x "
   312				"fragment_reassembly_remaining: %x "
   313				"reassembly_data_length: %x "
   314				"reassembly_queue_length: %x",
   315				server->smbd_conn->count_reassembly_queue,
   316				server->smbd_conn->count_enqueue_reassembly_queue,
   317				server->smbd_conn->count_dequeue_reassembly_queue,
   318				server->smbd_conn->fragment_reassembly_remaining,
   319				server->smbd_conn->reassembly_data_length,
   320				server->smbd_conn->reassembly_queue_length);
   321			seq_printf(m, "\nCurrent Credits send_credits: %x "
   322				"receive_credits: %x receive_credit_target: %x",
   323				atomic_read(&server->smbd_conn->send_credits),
   324				atomic_read(&server->smbd_conn->receive_credits),
   325				server->smbd_conn->receive_credit_target);
   326			seq_printf(m, "\nPending send_pending: %x "
   327				"send_payload_pending: %x",
   328				atomic_read(&server->smbd_conn->send_pending),
   329				atomic_read(&server->smbd_conn->send_payload_pending));
   330			seq_printf(m, "\nReceive buffers count_receive_queue: %x "
   331				"count_empty_packet_queue: %x",
   332				server->smbd_conn->count_receive_queue,
   333				server->smbd_conn->count_empty_packet_queue);
   334			seq_printf(m, "\nMR responder_resources: %x "
   335				"max_frmr_depth: %x mr_type: %x",
   336				server->smbd_conn->responder_resources,
   337				server->smbd_conn->max_frmr_depth,
   338				server->smbd_conn->mr_type);
   339			seq_printf(m, "\nMR mr_ready_count: %x mr_used_count: %x",
   340				atomic_read(&server->smbd_conn->mr_ready_count),
   341				atomic_read(&server->smbd_conn->mr_used_count));
   342	skip_rdma:
   343	#endif
   344			seq_printf(m, "\nNumber of credits: %d Dialect 0x%x",
   345				server->credits,  server->dialect);
   346			if (server->compress_algorithm == SMB3_COMPRESS_LZNT1)
   347				seq_printf(m, " COMPRESS_LZNT1");
   348			else if (server->compress_algorithm == SMB3_COMPRESS_LZ77)
   349				seq_printf(m, " COMPRESS_LZ77");
   350			else if (server->compress_algorithm == SMB3_COMPRESS_LZ77_HUFF)
   351				seq_printf(m, " COMPRESS_LZ77_HUFF");
   352			if (server->sign)
   353				seq_printf(m, " signed");
   354			if (server->posix_ext_supported)
   355				seq_printf(m, " posix");
   356	
   357			i++;
   358			list_for_each(tmp2, &server->smb_ses_list) {
   359				ses = list_entry(tmp2, struct cifs_ses,
   360						 smb_ses_list);
   361				if ((ses->serverDomain == NULL) ||
   362					(ses->serverOS == NULL) ||
   363					(ses->serverNOS == NULL)) {
   364					seq_printf(m, "\n%d) Name: %s Uses: %d Capability: 0x%x\tSession Status: %d ",
   365						i, ses->serverName, ses->ses_count,
   366						ses->capabilities, ses->status);
   367					if (ses->session_flags & SMB2_SESSION_FLAG_IS_GUEST)
   368						seq_printf(m, "Guest\t");
   369					else if (ses->session_flags & SMB2_SESSION_FLAG_IS_NULL)
   370						seq_printf(m, "Anonymous\t");
   371				} else {
   372					seq_printf(m,
   373					    "\n%d) Name: %s  Domain: %s Uses: %d OS:"
   374					    " %s\n\tNOS: %s\tCapability: 0x%x\n\tSMB"
   375					    " session status: %d ",
   376					i, ses->serverName, ses->serverDomain,
   377					ses->ses_count, ses->serverOS, ses->serverNOS,
   378					ses->capabilities, ses->status);
   379				}
   380				if (server->rdma)
   381					seq_printf(m, "RDMA\n\t");
   382				seq_printf(m, "TCP status: %d Instance: %d\n\tLocal Users To "
   383					   "Server: %d SecMode: 0x%x Req On Wire: %d",
   384					   server->tcpStatus,
   385					   server->reconnect_instance,
   386					   server->srv_count,
   387					   server->sec_mode, in_flight(server));
   388	
   389	#ifdef CONFIG_CIFS_STATS2
   390				seq_printf(m, " In Send: %d In MaxReq Wait: %d",
   391					atomic_read(&server->in_send),
   392					atomic_read(&server->num_waiters));
   393	#endif
   394				/* dump session id helpful for use with network trace */
   395				seq_printf(m, " SessionId: 0x%llx", ses->Suid);
   396				if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
   397					seq_puts(m, " encrypted");
   398				if (ses->sign)
   399					seq_puts(m, " signed");
   400	
   401				if (ses->chan_count > 1) {
 > 402					seq_printf(m, "\n\n\tExtra Channels: %lu\n",
   403						   ses->chan_count-1);
   404					for (j = 1; j < ses->chan_count; j++)
   405						cifs_dump_channel(m, j, &ses->chans[j]);
   406				}
   407	
   408				seq_puts(m, "\n\tShares:");
   409				j = 0;
   410	
   411				seq_printf(m, "\n\t%d) IPC: ", j);
   412				if (ses->tcon_ipc)
   413					cifs_debug_tcon(m, ses->tcon_ipc);
   414				else
   415					seq_puts(m, "none\n");
   416	
   417				list_for_each(tmp3, &ses->tcon_list) {
   418					tcon = list_entry(tmp3, struct cifs_tcon,
   419							  tcon_list);
   420					++j;
   421					seq_printf(m, "\n\t%d) ", j);
   422					cifs_debug_tcon(m, tcon);
   423				}
   424	
   425				seq_puts(m, "\n\tMIDs:\n");
   426	
   427				spin_lock(&GlobalMid_Lock);
   428				list_for_each(tmp3, &server->pending_mid_q) {
   429					mid_entry = list_entry(tmp3, struct mid_q_entry,
   430						qhead);
   431					seq_printf(m, "\tState: %d com: %d pid:"
   432						      " %d cbdata: %p mid %llu\n",
   433						      mid_entry->mid_state,
   434						      le16_to_cpu(mid_entry->command),
   435						      mid_entry->pid,
   436						      mid_entry->callback_data,
   437						      mid_entry->mid);
   438				}
   439				spin_unlock(&GlobalMid_Lock);
   440	
   441				spin_lock(&ses->iface_lock);
   442				if (ses->iface_count)
   443					seq_printf(m, "\n\tServer interfaces: %zu\n",
   444						   ses->iface_count);
   445				for (j = 0; j < ses->iface_count; j++) {
   446					struct cifs_server_iface *iface;
   447	
   448					iface = &ses->iface_list[j];
   449					seq_printf(m, "\t%d)", j);
   450					cifs_dump_iface(m, iface);
   451					if (is_ses_using_iface(ses, iface))
   452						seq_puts(m, "\t\t[CONNECTED]\n");
   453				}
   454				spin_unlock(&ses->iface_lock);
   455			}
   456		}
   457		spin_unlock(&cifs_tcp_ses_lock);
   458		seq_putc(m, '\n');
   459	
   460		/* BB add code to dump additional info such as TCP session info now */
   461		return 0;
   462	}
   463	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--wcydptwka6obxnng
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICMlL110AAy5jb25maWcAnDzbctu4ku/zFaxM1VZSZzIjy44vu+UHEAQlHJEEQ4CSnBeW
IjOJamzJK8lnJn+/3eANJEF6aqcyiYluAI1G3wH4119+dcjr+fC8Oe+2m6enn873fJ8fN+f8
0fm2e8r/x/GEEwnlMI+r3wE52O1f//7jZXPcnbbOp9+vfp98PG5vnUV+3OdPDj3sv+2+v0L/
3WH/y6+/wJ9fofH5BYY6/rfz4+Vl8/EJR/j4fbt13s8o/eDc4CCASEXk81lGacZlBpD7n1UT
fGRLlkguovubydVkUuMGJJrVoIkxxJzIjMgwmwklmoFKwIokURaSB5dlacQjrjgJ+BfmNYg8
+ZytRLJoWtyUB57iIcvYWhE3YJkUiQK4XuJMM+3JOeXn15dmLW4iFizKRJTJMDZGhykzFi0z
ksyygIdc3V9OkVEllSKMOUygmFTO7uTsD2ccuEGYM+KxpAcvoYGgJKh48u5d080EZCRVwtJZ
LzOTJFDYtZqPLFm2YEnEgmz2hRsrMSEuQKZ2UPAlJHbI+stQDzEEuGoAbZrqhZoEWRlokDUG
X38Z7y3GwVcW/nrMJ2mgsrmQKiIhu3/3fn/Y5x9qXssVMfgrH+SSx7TXgP9SFTTtsZB8nYWf
U5Yye2uvC02ElFnIQpE8ZEQpQucmE1PJAu5aV0hSMAaWxel9IgmdFxg4IQmCSkdAp5zT69fT
z9M5f250ZMYilnCqVS5OhMtMIkygx9x05ss2Rfn+0Tl864zdHZqC5C/YkkVKVsSo3XN+PNno
mX/JYuglPE5NSiKBEO4FzMoSDbYrK5/Ns4TJDI1HYie/R03TPU4YC2MFE0TMwvIKvBRBGimS
PJg0l0CzW2GQ4/QPtTn96ZxhXmcDNJzOm/PJ2Wy3h9f9ebf/3rBDcbrIoENGKBUwBY9m5hSu
9HDXKANRAgy7vVJELqQiSlqhseRWpvwDKvVqEpo6sr+PQOlDBjCTWvgE8w3ba5NeWSCb3WXV
vySpPVVtzhfFD4aBX9Q7IFpSxBeF7ZZWu43m18/knPvq/uK62WIeqQXYZJ91cS67ki7pnHmF
vFeSLrc/8sdXcL/Ot3xzfj3mJ91crsgCNRzRLBFpbKMVTZeMCWx7s+hUySwyvtFM6W/TpCTQ
ZBNj7rX6Rkx1+sLC6CIWwApUJiUSux4WDEDnpmm34zxIX4I5AfWgRDHPipSwgDzYHGSwgK5L
7cMTr+3TExLCwFKkCWWG+0y8jteEho6zhJa2j4QG0zVquOh8G44QAhsRg4GBKCbzRYIWDP4J
SURb5rSLJuEHmyZ0PEXxDZpDGfSG4AFWSlkPri1/GkEsNYP4IgjEygifYt8kZFAJQ3COHOXE
GH3GVAgWJGv8SWsje83+nERgp7tusLC/RqvWKzPCMzSYBT7EYYkxiEskMC1tTZQqtu58gigb
o8SiRS8whgS+ITWaJrNBeymzQc7BQzefhBtSwEWWJoVBrsDekktWscRYLAzikiThJmMXiPIQ
yn5L1uJn3apZgIqh+LIlV7C71ZxWZcIN1XGPb1c2II55XlsTzZgCxTlrO/Ay4Yjz47fD8Xmz
3+YO+0++B/9AwLJR9BDgUht30B6inlkHFQUQiMyWIcottfqjfzhjNeEyLKbLtNtsSR4G+ERB
dmBInwyIaxImg9S1qSagwWYmM1aFku1OAPXB6wdcgp0ENRCh3QTOU9+HFCMmMJBeMgGTao0v
hM+DyumXnGhnOzUqSbg0QlUMGlzc3MjjJDJEMTTcLIQFEF+ArV7J1LCQlT9r6WTVOF8xiKlU
HwDyx90ETDrwBqx3ZxZttDKYJi4St4rsWZHOBbBboDHTQrzi42Gbn06Ho3P++VJEHy33Wa/5
ZjKZ2PhGbi4mk6Dl/KFt2kY2QZeIPgC8XQ9McnFhLETzv9hSNOzZ1cLtQSUaNshggRdtyQlj
ywQQVmvWGbKrjbwPJgAsCmwtss4cB2LkCyutAJh+mnRQLwfYUYxiH+YehqmJwTRDk9RO/9bM
zkkNyUCgmVXDxzZd77r7enIOL1jbODnvY8p/c2IaUk5+cxiX8PdM0t8c+OmDkd7IlgzM49im
1lyAVoB7Nq079MwCInm7ZUXWrYBSEstwiOjxyBgMiM0C1wgwuJAk5tRsQBKkxqk58s8XXGgN
+YhS5pxe8u3u227rPB53/2mZYVA/TK4MKzEnUnKZBRRCGrMEE3u0AlobdRWnDZGqFsdqR4cI
qulhFK1xt46zOW5/7M75Fvf+42P+AsOBpa9YYRSrEiLnnUBBFDaT3T+3fFjdbEqqTnjtadG/
0zCG/XdZMOQVy97dOknClB1QtGI1yu8EcE3irgFzIRZ96womQue/mZonkMR0TMLl1AVVFL6f
qc64CZtBQBF5pa2HLFEni2ac1MzfrHocaoYhJhkaNwp5kS7RMF7T+cw2VLnxaAxUK9ocaC9L
h3oNwEjFKDhMnZV3Rg+FV84QM8p9U8UAlAawAxhpoB3GNfTolwVI+26w4jbaAWluUBYAERCb
0QVohGfs+vUVbgmGmL3Qo9itDgj8dSQy5gPNHAMX3+/a/YIDIAyqqnIlKyMAtoGMhMrXkZCO
oa0Sj1mrGTO19KJQTyqWH79uTvmj82cRjb0cD992T0XFoqkaAVpJhdXOjw1T25MgnfFI1+ko
vX/3/V//etcPgN4wE3W2piCvgdzAVEkdS0sMN5u6dSkfJteKJkzWKGb/xBYilzhphPCutJVd
a6A5clkLttufsrtMaF0yHti3CpPPxsAoeZC5j06mk8Ys5GDfI6PIkPEQYzZ71zQCdQLj8hC6
IrCjgFiGFd4CM5lBJkrAZchosUi7BXsgDjNJyV0zt3TLWkv9CXkqlRzE/XPKZCvGqkoHrrQz
yoAPVV6b6oNis4Srh1GsL2AY7AkXYtDQg8Aec4AE0rNBtJVry9OLKTB38mV3jchmEZOgp77x
5njeoWo4CuKrTiCdKK5rC5DCYtnCKujSE7JBNbJmn7eaG//fmdEkP/yMUVFdnRZNLcxw8IAE
kZIuKnng9JBhhoY1wMWDq71FE5iVANf/bK9Yt+ZrBE1viYzB9KDKgkGEGNwURA1H/1vCx2DW
visQGzbU2QSWvTV32N/59vW8+fqU61NBR2fAZ4NPLo/8UKHratVQ2pERfmUe+vDqGARdXVkR
NXSoGEvShMeq1xxikvlsDokjmps+RKxeSZg/H44/nXCz33zPn61BXZndGIUdaADX6DEso2Rh
64AmDsA0xEozDDyovL/T/7X8LW1La8hnkKS2mpYcfIQSkO+2tGkhQ4saVMwLgRIYDFXGS+6v
Jnd1ybiIP4pMtz7i8QkP0qQVf7YhtjovAxGGiF0HB4uwVUsMGOgpASG3mg4/EeDBV8RegqUD
B29fYiHsTuaLm9pN2RfZr9lUyyPrMujU+XDo3t9ODA31qgIIBr0L8Dj27JsluPjh84tZGmcu
i+g8JMnCquvDMtfw2RB0uXAxRWeRds6VCkb5+a/D8U+IUfoSCyK2YC1fU7RAEkhmFsakETfC
NvwCbWvtrm7r9m4camBzoWs/MZQGv8BnzkSnSRd3n5uxdCP6s8QHV2+dTqPI1AX3G3Bq93ka
p9CssUFgF7lUnA7Rj6cWwjyrx5OIBXswKS6bbLPV1tTcTx4XZW1K2vEAtFfOLksEBIi2Ahwg
xVHcGgy+M29O+42uECruzIDtCUnsaogr4TEfA87QZLMwXVutA2JkKo0ina+Z84Z6RQPnLxHY
RbHgA5lvMexS8UGoL9IxWEOUbZtxczIyb3yIboBI09zjqg0z2m7Y3UYqBGZonpo3ZiPqVWd6
ReOquT186sXDeqgxErJ6AwOhsImQngm78uDs8ONsLPiqcWjqmklt5Y0q+P277evX3fZde/TQ
+9TJD2pRWV63RWd5XWoDnl/79lUhUnGShcqceda8CNd+jTv9s92CW/2zzaLrob1u4dS2oU1I
yOPrwT7aqNik4NqqNzBcR/BNkOSqhw5t2XViJRrBkYdlXwxe1EPMer0LGoaZrA1XjEUfLK3Z
9bVAHNb3gkw2u86C1VvzaTTwpPb6LbANb2VhkabrbA0LEKsYb4ZBpua3rkNUveP5gy59gDMI
4yG3D8hFCcieGMUjQLA+HqV2owowSZUdlngD6SvInf0ejrKf7gTTgRnchHszm8MqymZoKiTp
sAybrIMtAxJlt5PpxWcr2GMUetvuOQRG/A4fU9PmEUWChXW89fSTfbEktufK8Vx0CKhB14FY
xSSy7xBjDFf16WpILopLBvZFUzstXiTx2oLA63f2nYG9JDr5tYJFzKKlXHFF5/a9kHjDaSBA
BZIhuVsMO4kwHiicFNcw7FPOpX0lmkGaUo/ZF4MYwSVE5xKN/BhWRKXNFmqvt8Zk6SFrn7C7
n4NOvOyc89O5Ux/URmKhZqwjAWW43uvZAZghuMEPEibE4/Y7gXRA2Fy7fBIf1pcMab2fLagt
L1zxhIGNbl+b8WcozBe9WkwN2Of548k5H5yvOawTs+ZHzJgdsMEawaiFlC0YResadJFgYZHa
SKtWHFrt9s1f8IESIu7I3UCqSLg9CKAsnmdDhbLIHzhLlWDzh+7wYTTn22E2z1XptlSZzoON
I5NEAHnFBYwmI4YsW3T0X2+Fl/9nt80dr3tWpo0ynrMZJZXeV1El7ZwSFHWtasn6o+EA5Qzr
AqA9dg5RnoVWtUPI55QnC9kZr6gEDo4mVTpgoQHIhV39ERYn9hRAw4jkdhs8hyQoSDVWvwIJ
bdvD/nw8POGdt+Z4stCJzWOO1zoAKzfQ8GLmy8vheDYvzr2JW27tafd9v9ocNaJDD/CD7A82
ilbXMu201+ti+8eXw25/bpVVgVMs8vS9Oauta3Wshzr9tTtvf9g51d7aVWnrVffE3Rh/eLRG
sigxL9MVh8zdb33+kVHzPBi7FTWzkvaP283x0fl63D1+zw1VemCRMsbTn5mYdlsSTsW826h4
t4VFDANn1sMUcs7NQ/bYu76Z3hlx/+10cjc114ULwFNEXZho3RRISMw77qQ5ot5tS3PhiLoW
1NRuijO0OQtia0kBPK4KY/Nwr2rJQjx3a90LUSTySNC5fNzIQFLM5fMkXJGEFe8HejT7u+Pz
XyjdTwdQm6NRal3pTTUPWvXllHrA1gOGGru4SdpfoAXTfuxUSmeXrrp+qs+h8AilVV+uuYXn
Hl7Ch4K5EoEtk4GMqUDA9xvlMBAchuAb7OE/ohH5ENEKWR/kWza2vgcVpzg7p+VZonlq2Zec
+mbLo/ZDrevBZrPheQW4Qtq5MNbUQ6OhQz5lN9jCt6xFl7BDvOdVuTQ84elc3RpoAGQzp6ha
QWY4sccfTUeQPN/2MMbAKK3TcxfUuepTNZP17e3Nna1CUGFcTG+v+ouIhF5I62gRdtV2ohil
QYAfljmol4iwQxb37JJWDYchgpQebBiPL6drezRXIachswWjFTgQIu6tQbfqowt90H9/24XT
5CFWouzbm9JL3OFjTc2PN+ByfTtCckLCPsXQWBLb3Mw3YToMvr64ujLUBFmPiQb1lnZ6CHoh
1Gim7ElWPcMbC0pke5eKDGgZsla00eUSwq2BMACybgBd5UDmoMWJGr4ENG1HZeTSMHzAQ8SB
7JxEauB2quJ+qC2vFcoiGgiZgrMBhdZGzh4GxhnE2/YCNGzYYGBZhUvDz+/WeCEWEh/PH7hm
SKeowL39YAwMd9gKJqslaUh2d0nX11aud7oaU7k3F5Mer4onTvnfm5PD96fz8fVZ31M+/QBf
9+icj5v9Ccdxnnb73HmE/du94I+m5f9/9NbdydM5P24cP54R51vlXh8Pf+3RxTrPBzzwdt4f
8/993R1zmGBKP1ThN9+f8ycn5NT5L+eYP+k3qA2zOijomQpHVsEkhUSx37wUcbu1KZqADepk
QZ1J5ofTuTNcA6QYaVpIGMQ/vNT3S+UZVmceCL6nQoYfjBywpt2gu7o6MMInQ6bo3C79eIAO
EQ7FZyLUnmBplETJ9T/ASKU9uZsTl0QkI/bHXS2j0cpdwTkZAbP+KGL7p3xzymEUyJQPWy2T
+pXxH7vHHP///Qh7hYWLH/nTyx+7/beDc9g76Op0tmEkA9CWrX2wuqHozIUGOeY2l4NACVBb
mR1AM689zszDoVrV9ro1tuXWxjy0d6FG+zwWLHj0Rk+v77d0Mz6RdgXeOkwSkVjHBzwgbaCA
7zH9hg+SdapsJRBEwKduxWWgQu6B8dsfuxfAqoTzj6+v37/t/m57iTrmCIjCJ0vjK/RCkknf
b/I9bk5kJur9vq2iSPGN4g0WIBOJ1769U3UTvu8KYj1dqVDKoNvaO1b8enrx9pI6JZoKShi9
fiv8IgG/+LS+HMcJvZurN8ahoXd9NY6iEu4HbBxnHqvL6+tRlH+D5UrEQD20kgbOx+fh6vbi
xv6420CZXowzRqPYTrbrEEne3lxdfLJtTuzR6QR2JxPBeGxWI0ZsNR6VLlcLeyxTY3Aektl4
8C4Dejdhb+yBSsLpnf3tRYWy5OR2StdviI2it9d0MnlbxiuVxcuRpeHva6u+OQlWuV0H4Wg2
lfXNLHYwLs5gd898RqlbOpZJU1BOXTz0eA9BzJ+/OefNS/6bQ72PEGp96JsQaVhXOk+KNtW3
uNJqSWQCRjjyrI+s6tFaT6vr1oEzH702qktH0cDJj0YJxGw2dMqpESTFkycsMPRCIc0rVUV8
p85OyZgXO9OqGCHEp/0ta2Nw/fcbSBJ/i8fbKAF34Z8RnCS2DVM9ge6s8Zc281b6YVjLlWuI
Gjrh1VC8ilO8Tx3Zu/XMvSzwx5Gu3kJyo/V0BMdl0xFgKaCXqwyUfa31bXimeTxwGqyhMMbd
kMWoEEZ3itCOs+2A5+Ti5sputwoEQsfpJ5zejFKICHdvINwNOdPCfi1Hlxgu03BkK71YZXw6
kLfq+fGKDkjWCEZCw4HDWQ1nQN/UDg/ZjGiDC76qdzzaxQngh4HbeDXOOCsgWHgLYTqu2SFJ
VPx5hJ+pL+d0VKAVFwO/J0CT8JDY85ti/ojbSwClK1pfXtxdjMzueyIkPBpMszTSzBuoDhWG
NB6zsvjLjUaECeDkYuARZuE74xF156EtXC/sJpH8ZjJpvOOnSwrfIDP4/qz9S14KTipmC8QK
2EMI3W/BOE07rr2BYBiN96BZ8XZEp3YXQ7jVlTUyk0Y5r4OFh9sa4/pqCCM0XzJq4Bc8K+m0
RTSxTXw7gFTPezkdwEBXfT+ddDj4GRw9p1hMHtnPzwF5y5lIHt5cjAzh0cu7T3+PmB9kz92N
/fpMsRIZX9pjdw1eeTcXdyMGdvi0uRDZ8A0fEIe3nYi1GzAVPr8s9I8Q0lFLM6DohLhNT3sR
IbSk7mZbWPxSE0jSGVWtZny3QZJWEy5/0mu56Le03mOXjVef7KkDgIvLgGTAGgGClu6BN0m9
pwKd1XqhPjxUPOpzwmudYADmsAh4+NILHyLGQ1e0wuJ0YQgoI/J/jF1Jcxu5kr7Pr1C8w0T3
oWfERVRpJvoAokASVm0uoLj4wlDLcrfiqS2HLEdM//vJBKpIoCqz6IMX4ksshTWRyKUym5LF
7Qb367rcalTP5xhrrIW1jQDQGdqMUqiannlYMvsem6IOPMp4OJRdGYB9UjV9VGCpo0PvRqTn
LycCG0aUnubuiGJH0r0uc+gqE/eKrXOrWPs4HGVelw5QdLPkRoh5vs0vGOBZUa+V5Z8wVg3O
naHgWSl1NZndza9+WT2/Pe3gz6/Uc8FK1wqVveiyW/BYlOZA7k+j1QQ6ducn5HNa3ylOWaTo
HOT0FuoefcLHV/Wxcc4VeWVBRlPLacUr5qEmFxLVT+kLWMVC2z2HoBSPeX9fM8q00AbDPABB
2/FiXmbUhmebIuwg+Hncup51/vgY3bQt90JYZDkjS4NrQE//1c8h1Kc7P+L0VKDS5+/vb89/
/MA3BeP1dkRg5BzpAXXKSz+Z5aTgYTdomm3jeeWFI8eZjF+rVUZL8FqNoJm8YRiNM0FyR/do
WVtGmGkP1aYsKWF70FKRigq28LCxbRIqzdQrzRjUnQtYq9gaT9nJjJRGhpkyuOHi0RF5PDGZ
lqWhBGRRVqtC3lRIVcRya59yLHPnG2ANjDrNJmJJtThac+kLc/EprDGCIiEf/Ewmkwn7Dl7h
VGZ4xnaki1z2FjdRK2xGhQ01y0KwlnQ6ztcyknEJm9FtAYBmLBGgVzYijKJvdmkyNHDSR69M
PuVYLJOEdJ8TZF7WpUh7q205pxfTUua4QdInMQqfSED2Lsfd6sKZNYuqhRIYfv8A98K8/5oe
ZqQsDOKvlCKNnZUVFAMe5MEMRegeJcK2uslpaKMy4y6E5x7wSUdLT4oTTO9xJ5gelDO8pRSo
wpYBSxgbFkuT3P3fhQki4Z4YfY2ixzPMAgOli2hGprQRSJApVb11Z5tM9xTuppPrObUYBqQu
4Zjv6I2rRXNGJOLhovdCGzRjvqdtUHa6QE7omDCyyTS/m1zTiwSqvJku6Nnf7mx7XcuSkrSE
nYgWHlGfZVPajsY0RYo2fuPlKWD4VeS/ZammF4dSfZIbXZGrY9V80NZE3ljbz1vl2w+T5MJW
ty7LdUYvyU00ATYV7X8szNCIndJkWTqZ3uwD02gUYx0h7W5Bk8MtIHoaUJwwTfX9mcUI8+6+
pkWPkL5lDCP3XBYAmErmbO30sfQhvzB3clFvVRb1S77NOdMYc888aJr7w/RCRVCLKMpomubZ
fn7kJNfZ/oa/lAFqdqPwanehPVrW8Xy4N0lyM4G8tNrpvfmUJPOBlg1dctmurVNu+Pbb+ezC
wnE5jcrp+Z4f6kjzAH9PrpkBWSmRFReqK4RtKzvfUHwSfXsxySyZXliv8F/0GVdEHO+UmU7b
PWngGBdXl0WZ07tJEbddH6E8mNEFcOs5arr32aBhCcns7prY5sSeY6AKNb1nXwDa3BVjTBm2
fKtTHZ29zvVT2uOphxnL++ibgZ70phHkaL1LqGKti9hf1QZ4fpin5KccFKrVr0gtprBwVRj0
fkYOjxdyhzV+zMSMe9H7mPV50PCKvlfFkYM/kjbwYUMaVKHLI/b5IyTAyckYL9f5xSGs09gE
ZHE9v7A2aoWXsejkTyazO+ZtGiFb0gunTiaLu0uVFfh2SA5MjQaoNQkZkQPTEek2GDyO+rc9
IqdSH+kiywyu2PAnfkhiREmQflzhcF2YeUZnIt5l5N30ekYpt0S5Yv0Hbe64FzVtJncXBtTk
PSsCv/5NLu8m0Bqahai0ZF/xoLy7yYS5XiE4v7T/mlLC7qv2tMTGWHfExEZDOSyCnxjepoj3
jqo65Iox0cAppGhpoERb/4I5YXRzoRGHoqzgnhkxzzt53Gfr3koe5rVq09ho8/QpF3LFOfRR
VsB4oFcCw7hGsBclG9t454efx3qjmVcCRIFDg2G1lIv7oNid/lTEjoV8ynF3w024E8HsEh/u
7zXEZEdgyjxrr9KUHmhgjkjNWmQ8W2uo8AFMD5xt+TSJ70ea28M9jbZLwbz7OAJYVRIYL03d
2WCYM73sdNGA6ApSutdCwspSpPjctKHfGUSe8lgr6+IJvF3SkiewyfVsz8LQVahKM4Ynt2N4
K4BiCaSWIuXb3wobWDwVMOYjxacV8p7TUdzKZDIZL2GejOOLWxZf6b3iB1DLKmsMD+Pd87jf
iQNLkqGyj51cTyaSp9lbFmsvchdxuDHwNO5ONAq7i81PUFh+JE63HJaicB73BN+Sj6PZWz5r
BHesEY8DezT6mXgU86BVk+s9zdOhKB42VS35yrf4kmkUi7cGTWvYjaY1/k3fRDJNubmqqiow
hawqDAnk3CRFialCJ4oqMsusOi/LdHUA5xVjkeBAfJJGsRfdqFLFLXAKrnGSs6m1NnqvNPRX
mmwTZG7M0rvGcfa4vRg3S+BHLH18IHgvdtwrB8KVWgvDuGZAvLZZMrmhj94zzsgaAUehQcJc
lxCHP9w9FWFdbWi2bpeFMR7w1/mhLPc3FAqz0TsW/BxR7QD0ZnBRJgvNQ2dbIRQ8ehBoJ/Em
oE7Sx0A1XB0iVrY0lnF9WdXa5LFzIaLQswyNAhVc9Nk+rUUrC6aw03WRAkNd+hAItdzDdMvQ
fzqk4S0xhBxToor4jaBl+2pxkENrPOV80lztntGtzC9DFzy/ou8atAp7/6ujItioHacRkKNY
hn5/8SoQRtOXDqe6QLh0OR/QJiWZ9m3E8sLPY9Uz3W4NB7/9eGctJXRRNaGLSfx5XK3Qo2vf
BZDH0E8S52rJUxjnCPo+Z+atJ8qFrfW+T+Qa3Hx/envBmBnPGAjny0PPHLjNX6IX7tF2fCgP
4wRqewnv7SBBf3K+dnzOe3Vw5l7nju1SYFO5X7LpaGwMKbJMY2lYj6pO9YmMlgd39Nn9PWPx
fSLZ6KxvekSQkK0p1M4ySiMnGvQ4hrLwCw01ttyJHaP5daZqiovfs7c9kuG8Ce5v+PNYmSmR
dBRZZaj05SGlklGiCP9WFQUCiyAqZK4oUB6caxEKci6FnR15dMU84SrDfZDRQAuqV3juMDLK
oLaykZt7MibnmWiF4V9bzZEI9H4xhu0UVZUpV/RI9XDLu+GUfT3F1sAtUdDKjG0Duk5mjYlP
OwO6+6TfNT2Jc1NJsy8tAX6PgTsJ80bUTjcMGkMLcfWcNrffPLx9dsbu+r/Lq761VBzzxv3E
v1vvJWfm0wGwD9NLwcNrI6OJD3uPSYMndNwY8jjyVFuuxHnOlpvppS+3l60WtNmiR1tdoF7B
/ZrNFLn1sWJqyZbROBISWotcDbVDWsU0akTONvTE6eqPq78e3h4e39FL1cmnRXfVskFMsW1w
/Eqv7IervjCZu2makLIjCAZpN0wDunMyurtPo9h+6JL7LjlW9hCU7W1w2MTWZcliHvc3XIO9
z6ki5eytivJTyT3awRRkHHf4EGu9O9k5I7qpsaTMMXNualHFPQ5iAie9d8V/Fqqo7X3P5Yw3
VXx6e354ISJO+e9Vos7g5C3iVQhA4sOSDRODCKHOkruMA5KGlCu8A1D30JBoMN4huA4j54VA
ZLUeAmovahoJD6swvaiPjait+X1yS8E1RvfNVUszp+sE3j0No3SFaC4K9MdZW6Z+sxG1aqNK
kN3orRtYlzFRYzkzxLA4ft86FWOnSUJ4znn9+hvikOImldOUJRSx26KwxzJNeoJvKfJmP+gT
SGPnRKxlHSQGOfqt+MAsyhY2UhaMCKmlaLfyD1as8Yt+gvQiWc08yHm4ZsKzt/DKZMesulSH
o9IFeiYYknYWOfHeMCjDRd1pKP1ZFyQ2DliQVd0gkIIndNEVOnGvcn30AWnpayJs+SOBOpEH
0z3tr9b1hbNNeiROq/PXHQrpPP9KmotHY1v0OjzndJPOBKzRbT1lvEboqvNHSw4J2/6A10LH
9ryXPSvhT0UHSNn2Oau9zrLDwOVp58tztBE4NnCyNcY6q27vV3B4vZxKaofAZKrKkDygnjHr
hdFINBVzRG9oB65V7Lm1MiPStsJWSDGceJD2+PLsXUINPxgLhUmHqjL3LroxI789UbmT/xJR
6xPvEtm6IhxmYoP/dAHb3l8jX64etRV8zuvjv4cyFvQjP7lJkjieeiuP8u94LkYo61c+EEw9
fP7s4lDBLuRq+/5foQnFsBHB5+lC2pp+F8bv5Twg72id46rcqfootozzX4fCpZa5Q3kcIwtl
9JV/s+PMUVCLPmfe9ncC3YWXVHwIgzLxc9S189Q3VBxVuI0KknzZizjkX19/vLw/f/nx9dFF
COPfYPNVCsxNylnkIZxmBX2Wbax0voolLWPMKnnUzAUbMc75B9b5QRSfjjIvOc1KpLlXecX4
p3FfZRezu1sW3uoKHUdxdwQkqVM5mzLqJYib/IaxtRXL/c310HddnPtgJDOfELZobTyb3eyP
1kiRMmISJPyY7xPGrhW/c5/c9DS7Oz9lY1MkOCXUusn6IbTPqBz5SpTld7G6BjN0/fbw7a/n
R3KnFWvqoWq7FsB2BYGf2wRnVr7GAGWTRXCZqmm2A9KPKfA5augSRkAWwlNsmOzpZHX1i/jx
+fn1Sr6eIiv/Cj++fnn+88ebc94WlfBTGbw/4beHv5+u/vjx5Quc2Wn/mr5adrENz70AaUVp
fUCQU1KkK9l5MIbxoGQvWCj8WQEfUUcm2C0gy+oA2cUAcB6bllkcuQVLghmh10UbHp2uEb0Y
tG6OTVSw1Zkr03oJwbBT/upkH8R2hg1zFiHk0ANa5fRehhkxzuGU4xeBALa6DL6HPj5cdxhL
ySkBMrFiFKSMC6ExyySdsNqfOOZOJ5ZDgbdkMc35mcFhEbYu2TprOCmYPQv7xx4m02QEZT+V
PkAQEVvOKRiimu29QpUwOTW9bQJ+f2AMwgGbpSu2B7ZlmZYlvesjbJPFlP0ai+6J+fkziLEX
Tlu2ULjI5Jw2HPZRbmTDf0+T0mwLTpNlflzv7fyGXxEY27FhGB+cTJ06OkuwTFgvgG582YAW
7stuJ73F3Pk+p/ZQ7wv84fHfL89//vV+9Z9XmUyHb5BnDkWmPtJSq2BHtgIjU2fOkTdP2rkb
H6/ZV/369fvri3M8++3l4Z92gxty7979sOwLWKJk+Ddr8gLOxGlCE9Tlzvw+P4GrWuRwY1qt
nGf5gSSGgDuhVlXDQVAzq5vIVpfWyZF/OkOq4FetgNcR96r/KN0xzVZHze7uv+NdepLRlutI
zRd/o+il2cNBVdA7RUADjMiEZsECIpk1djqltCMcETovN7KjCr9hwCmdvrlsilBg2fvhbmx1
nFTJPE4w6uNZhfR8BQEErhpoKkf1tS+IKj89FCLXqCJalOHBjhiyadLFcQ/c/2ATPIeIT75H
76M2rOfk4TBI7Hy+IhgHaY5RXVjGUhCb2pcPhEX4CE6DrmrQerbuV+j6ENcWU5qQd7dHfBqX
vc4a6li55H5RESrQdTyLwo6ca0aN2I2BrQStYOBRs2CcG7nP9CLhyeKG0dJyZVTNnHNBhOMJ
I52LYrrn63Hd1V7HxZYUPbsJ2JspIp0kyV2/M2Gn0Zxs+AQ7bpQRMSNRkySc26gWno7DsxF4
x0iKAVva5JYxbwBUiuvJNb3tODjXrO81XN77A+cGz+U282nCDyPAC85TIMJ2v+KrTkWdiZEe
W+tiDM7EYTS7L56fX654HvbF8zgcCMwDDYKcUy3A0G35jPHuBTA+iq4ZQ9ITzFmangjSDxdL
4IetK4KnUIWZzG75vvc4P29WeTKyOWxSwy9VBPk1CgfY5HZk1JyWY7LnW94R8FXcl/V6Mu3z
nOHMKTN+9LP9Yr6YM/c9P3X27HsQwEU+ZdyX+d1wv2H8YgKK0ea5yCgOzxXntc6jd3zNDmW0
cv2pwbgA8MeVSLgLQIBf2J/dNaQ0/NLY7qdTvoWHfEUFVNukvzmRTfTs5Oah8JOF5PNPuf6j
l6VCBdUMmBkfTmUe4o1Z9s8t1EgWDWtZ3lI0YjKynLzCthbMm3NLsej78xlQbDQbv9ydUjJl
xSZdEVXJeC0845txClsWhD5Mj2gLTLQgnW16llXGtmR+blQuwCi/tFI3DpLyROKOE9Nj6zZw
Iy+Lw4BLJE2PHbMTxHnb6HR44YPESAVbpxhVFRjUA9x7alWsGa17IORUnJoNKQvEos9u/732
ybenR3xixgwDFRSkF/O+0yaXKmXDa9h5ipqMve4wVNAbFImJmnlrRrypeyaWYYe5KBODblS2
rI4ramwRlhu4eAaCVZ+mZW94XXLZrAXftlxIWP7My5J295xU3yvG+bGrwMnTeRi+3cJ94miW
1zekbbWjOul1RplhmqzLAi6g9CpHEpWbXj/FcKYk89DvYSrymEM+wVf327NW+VIzTzMOXzHS
fQQ3ZdZTWYpgqG58Xt4f+F5opLPSZ/GdyCxzPUN4q9XOlLSzIfddh9qJRvr9geaCZHBrxOxg
oXwQS+ZBD1G708WGlMv77inQzbAdNiKT7lLGlpupotxyw4zdRm0TXTr+qOiOO5Ew0w/xusmX
mapEOh2jWt/Nr8fw3UapbHSaO6GyU+0dIcksFwTE44dVJgxlaYRwrfxijDcdbwVYrmwvuUQV
nuH6cQZk47O8IG25PVLrdb9EdClIqQG6vUsU+ASelXV0TAXJY11aqcLF5uQKV1Zkh2Lfb1AF
u3DGuD93OKqh17jW+C3VSS5p7tMPBRTAsM0OL6UUNOOwcQ7iNd9nhOcIl1wplfYt/2IK1nNo
i8IMhuNbUSpfjqIp0Pi2X3HNqdvgroQq5cKMHD7OWf2H8oAl8/uOZncH2DONUgMmx25QN8nL
4vgtGXmcY8U8IvlNeexo2muYfyyKnoNHvwotwtigP65vYEN1rrmYYGLIuGR9lwCddh/Be3mL
JLOkWUXPrw96smJ8I7fkA6ujtv5BNadrTpAYVl1upD7i622m2uffQMsb8FbWGyeis5n4uHF3
m6zSjOqiuxxhFNWNMMdNGBvM36QCsl78KZezKGC/kQqNhbpgsoPbH0Zxe3p5efj69Prju+uH
11M44qCszu09PmNrY/tVxeJwdgRKuz7uNhrtYQy1D/rLoC1NA/uDE11n4vD7NIR9B57nBob3
k+ew1Onwrdz1/OJ2f3195MJIIMkeR3SMQF0iKPfNdHK9qUaJtKkmk8V+lGYF/QQl9Wn6068/
IU6p1GQ4Y3yUNjcbzyVH+U2GbhTGWl0nYrG4gVveGBG2wEVDznsHzmlEW/M++fLw/Tul+uDm
iKS3ObcQvLovi+9SPq/Nh8oyRWnV/1y5LrBlja/0n5++we7wHWMTujgBf/x4vzpHmLr6++Gf
TjPx4eX769UfT1dfn54+P33+3ytUJQxL2jy9fHMBD//GcPEY8LD/pR0l1VP674c/0YqWUBt2
KyWVCSOtcDByWtz9AQh0xWs8uSWVFsxR5Ep3g50yyuNuy9gx+nQtyNu/4xK6XVyTfdJziB1v
tMbcMuJ019WD2NKnUuNNkile5XrBNxrQKS1cdBM6bWzDW/QbtTWKlqg7hwBqXVr2yuIoRpZk
e1WGf2/lgh8SeXDqn/yopPx1wW1qNtXOZpLvBBR7pDC6XBgC9yX8h6DploRjDu6EnBqfa2i5
E3WtRyjYsMH+GDDKRxZG5y+2GVki2qDOxIoRTAHBAXLzo64+uX5jXDO7zkDLAOgtVQ/afJq7
1V//fH9+BN4qe/gH1eOHk7coK38CSqV59ogpJ27QWqRrRsRoDxXjat8dHqj/MBLRIc8ZzVCV
8/akyPfAjKL5ESElBhpa6owLAaHh70IvRUGdwrWVR+8FKkhw2jFx0kYCO3OgEzuFhH+9vT9e
/yskQKfZcGLHudrEXq5Tc5GEe+tHrGjN8NzQ1+jeJDTyDwjh/Fz5wHdx/S4dVRGI5F5U+zD9
2Gh17GtYxK2ut/T8RRMLbGkvwgHaUjDJqMzP5KpeHt7hrP27hw1akprJlFE0DkhuJvR7REhy
Q++mAckiuTmugHNmBKYB5e2c3gbOJNP5Nf0s2JEYez+5tYLWXOyI8nliL3w9ksxoL9ohyQ0d
tOFEYvLF9MJHLT/OE8bpdkdSVzeSeRrqSLaz6+mQW3j9+pusmt5k6OUkAgN30MrC/64nw3Lx
xmievmKIcGaipWiIQN/GAFo2q+AKdsrkHB2tdF9NsAvgEecLdrlmP3aiVqJg/BU2nHNeXZ+c
JhEbDcLoPk8VkZ/wNpnT0+hy5YTtT/78+Pb6/fXL+9Xmn29Pb79tr/788QSXvlCX8RSRfJz0
XOG6VkNTsq6nrWCDrW52sMkUaEs0aKd0xj/m9cfbIxljhcSDg0zobFlSz0S6zPMmECh4qwK0
hnp+vHLgVfXw59O7s2kyw165RBoceK4md4ashnOzfvr79f3p29vr/1d2Lc1t6zr4r2S6umem
Lyepkyy6oCXZVq2Ho0fsZKNxHZ/Uc2I7Yztz0vvrL0CKMikCSu+ik5of+BQJgiAILEnuGcRw
msDdgZygRGZV6Mvm8ESWN41zPTHoEq2cagOAyv+T/z4cV5uzdHvm/Vq//HV2QNXS39B/394O
xOZ59wTJ+c6jPhcFq3xQIIbJYbK5qDLI3e8Wj8vdhstH4ur8OZ9+Ge5XqwPIXquz290+vOUK
eY9U0q4/x3OuAAeT4O3r4hmaxradxI31lHpV4ZodzNfP6+2bU2adqfZnd+eV5MenMje6xD+a
BQYPxMhnd8MsoM0HgjkGguKEz5SxBw4Z9pkUtHYUZLO2DvDUwJn7dhgf2C+hZxQbdDCjWej2
m61IPhpE6+ICxPGIeCGL3gfz158HObjm56o3yi5HotUkTQTK+ry7Tnx9OZ2L6vw6ifH9K/Om
1KTC8sgZYjfVyI3nZI9xkBV7A7fPICOD1LjYAtve7Lbr425PDXoXmTHCwuWrYvu4360frXdh
iZ+lbU225jA1uSFPkJYgWtw3fzZSvZJUZhhEbIkqJMoxQkGf9ZXT0rYhhlaXu0Wecg6nI8Zs
jLXVi8KYm6xSywf/TwKPPnBKvyltnYiWl2wfYurx1RqYppovFiu6E1HoiyKohnkl/atRZvmA
we4pDAdUwDfOK9tou06q5hjJnCgE8As3y4WsOM3DOZxZaWFNU+WBV7YjGp5ILt2yL/+o7Euu
bJuIO3z+GPiWTyL8zRJDTbEKNGpJ3UEI4w4YE4z9Bw/NeQiknHMOGxQd1SVh1JF1eM7nBIRe
ruZ3MCcRCn3tz6bSqgHKoVU6peRwPClUiFv+h2L0FlTAntXGzfYFiQyuyj5cyYm4nA3WfqHp
txNClSA9QlkVCwWQdd6WaUGzDrwtGuaX3HArmP0Y6LmMwfD5DZyaKkIQ9hbLX7a6fZgTcWC1
3K+oFbn/KUvjL/6dL7nNidnowcnTm37/q/UO5Ecahbb/9gcgY1pd+kOnQ7oddN3q2JnmX4ai
+JIUdLsAa/GOOIc8rao0v2yojdz6/hBfh0zFKPh+eXFF4WHqjZHHFt8/rA+76+tvN596H8xZ
ciItiyGtykgK4pNrxk/3VO30h9Xr4+7sb2oEnOc5MmFiO/mRafjevYhaidhlvLoMYfFZpiMI
euMw8rOAMlSaBFliPQqytXJFPLU/i0x4h6ErGm4PAilhWBvZWRxY/eEHlhi8pkh874UMR4UC
tBqcZiIZBfwSFX4HNuSxQPIwDh3zGQGSPtu5baGjrYOO5vCQl4mYgfLbUuRjBrzr2NjiMIEJ
wHG2uKP3Ux67TeaXnWifR7OuSqd4ycmYXd/nd1y2smO4M5fra+ZQe3qx56MGZS77991567cV
91KlsGtNwrRWFqF8JigHEFmaFlXSaohv/3Lb4RMNsdBLJ4OUIGCXS0smrBUS4R33ezTougtH
1KXTopZ0KzhFL5BGR7D69k/VTmOQGqsZPSfKJJt67d/VyLb2rVN550heMB3TU8QLYegN/1/4
G7WCBel5U6L44mEGso0UkoPae6PFPpFqFogJnObRmoe+5ZJU5RQtqHmc49wSlP11KpapTITX
Bsf3mNIHMsOnJOE77Ut9wXNrbkVG5kSPcr3BWxKAAWsRogIRws7YIFeAbGjk6huDXH/7yiLn
LMKXxrXgus/W0++xCNuC/gWLXLII2+p+n0VuGOTmgstzw47ozQXXn5tLrp7rq1Z/QArG2VFd
Mxl6llfQNtQaapF7YUiX37ML0cnnNPUFncy0/Rud3KeTr+jkG6bdTFN6TFt6rcZM0vC6yoi0
0mSOmIqRwmCHZ0w7NIUXRAWj0juRJEVQMh5LGqIsFUX4XmX3WRhxXrc10UiwjrkbkixgTKQ0
ReihUQvjgVfTJGXI7J7m8L3XqaLMJiFpUI8UeB6yrPaS0HOsurXnEFPXVfveXb7u18ffrvkn
7ghmufi7ytBHQA7nOffcq6U6ZSkqvQgG8DWSESM110XSgpzSRQQ+TwJA5Y/Rz5B6UsKI0rX2
qvLjIJea7iILGcVhp6ZLg+RWNhZ3AT6L84Mk8KWKA31KSenAE62jn0NGV4cuRDxJgxaTypEU
UbM+FJ/6KQwRKcrj7x/w/vFx9+/24+/FZvHxebd4fFlvPx4Wf6+gnPXjRzQHecIp8EHNiMlq
v109SzdUq60RrUNfoMWrzW7/+2y9XR/Xi+f1f7U3sLpOOIIU2Hxvgo6qrbOkhNJEjUvTdEbf
pImHsBJZWn0BTDdJw3yPTl5mW6ugEa5wGqZac+7tf78cd2dLtNrc7c9+rZ5fVvtT1xUxdG9k
ufmwks/d9MD0mm0kuqSDaOJhGJ+MR9xMKHWSiS5pZioNT2kkYSOuOU1nWzKZTonuY8QpN1nF
7XU7WqdbiuUaKmkVvZ2x8sMcAw1Iw6PcKX407J1fx2V02v5qAB2gO9SYSLVE/qGsx3Sfy2IM
LM4pD9v0fVNrpV5/Pq+Xn/5Z/T5bymn3hG5yfpvqR/0xGIfaNewzZw6FBt57eObnrv9N8Xr8
tdoe18vFcfV4FmxlE9HP4r/r468zcTjslmsJ+Yvjwlkhnhc7AzySac5IjmGjEedfp2l037v4
SlsfNWtmFOYtD202RR7chndOzQHUANzmTq/ygbTY2OweTQM53Z6BR33vIeXRVINFRnWsII+g
ukUDIkuU0RalNZwO6SvmGp5C07vwecHpqdTaDe5nGXN9qscfn8MUJRPote5Zntu2pupGcnH4
xQ04CEDOFxvHgvoM83e6eNeKDap04Oun1eHo1pt5F+fkt0agcyDn/Dm/KaLoffVD6lW2Xg2S
a7tzgFoHLT7nXzrjFfvfXEYawrQPIvxL1JPFPufr0KDoM77HGwrOpceJ4oIMYazX61j0nIZH
4QABKNqB+ORvvXOilwDQppoaZ9wSargA2WRA+j7WDH2U9W7One8xm6r2KGa+fvllWSEa/RRB
7mRWaS7zyyvyxavGk3IQuoXJSjLvkioRkvnyBjIevJyjNKD1dwTrE3EAZzTRwTIFHjH4/HnR
sQAQ7pMdVSG+WrujHfarTh3Kv3wdk7F4AKmNmFEiyjnfTa0trXNmBWQQ+wbNpnC+oqqPOz5Z
EQhnWIpZSn7FOv30EWoHjpuX/epwsAT+ZiBVmFB3MKMH+mBfw9eMMXCTm9ajn+BxJ9N/yG1J
TJkfLraPu81Z8rr5udorS8mTU+P2wskxzHeWdCxzPxuMtO0rgTDblcLe2SskkUcrfk8UTr0/
QnSfEqBF1/SekZXRGeG79TeEeS3W/xFxxtjRtunwmNNFOKYlHpHfx+h8FU7IqAbAJybubf1q
f0TLP5BCD/Kt3WH9tF0cX+Hotvy1WmIcStvOGu+EgHtJl6d5o7yg79T/oGxZeLT+uV/AyXS/
ez2ut7bxAJrkheSsGoSwsaChtXHHrC3tYM9JvOk9HIvTWBtTtEgwvGVZhJHN2NLMDym3HI0J
nxe2TZk89H7uwUwy2YPX69vzyatcYcaCw6KsaF4KklSrrAsMnBcN269CbIIo9ILB/TWRVSEc
w5AkIpuJglZdKYoBo7IDlHEe6bV2ShO4IroBe1EtXloc3GNeaMgwJt0D84DbG0bSURzYTD3x
ZV37AzJrPHXbERCBk5Lp84fK8uypflfz676TJo0spy5tKPqXTqLIYiqtGJfxwAEwwqlb7sD7
YU6COpUZo1PfqtFDaExzAxgAcE4i0UMsSGD+wNCnTPqlu2JNRWHD4vLUC5XHI5FlwnTSJKTR
oWnlqZKkl1lrBWO6bzY8AcGiyuVbFPRnMyrGLQwBKEIqII1J03gjkO9RkGiYZifHup1U3tTY
FzExSRMvHcvtSSmSJb35JZEK9wfWh+0oUoNmFHxr6GeSCC9LiYEuUjjv9K0b8TC7lSF2iWpS
6SRlBNuB6SRrmEK7HUcPmGpxXEl2/UapI2rI5qQysf/GvC+T6NVbj2Y0Ep1ioLx2jTaJgG0g
6SZBG5Lq8o0+t+k2Mh7TEe19fet1FJ+XCXa8k6B3/sa4M5QUINj0+m8X1KW86iR6kkB/XcbX
ydECPI1aUzVJEZDqH4MUNgC1iAxtPIoCJANuZAJnq7eV6VrgkKkv+/X2+I98tPi4WR2eqIdf
yruz9EFN37MoHO/kabVn7Vw8SkcRCBNRo6+9YiluS7Q4bDw3xsCv8NbUKeHSuMVBk5W6KdJr
B9lW7SaEsMqoR48dkebcsX5efTquN7WEdZCkS5W+p8ZP2TbAnkj55AkSqQOOMTIY8B/PCKsu
HbRXM5El6Fr+qz0JpsCX0Zo+5h5SCF8WLHI6uBk2ybTvGQcYmyhHC5JCmApmDbQah8Es4/Ah
gAwRrFPbhlcVn8O8D9MEre9i0XpWrXvSIpG9rdIkum+tj5mA5aQGRAZEtmOZmOluO4Dze0Ft
+hLITYAWpf/00zazEj2Uobgug1G6ic1dkfrG34EdUVRN5GSr0Wh3GTipaMiolcP1VZO/+vn6
9NQ6Q0gbAxloM+esqFWBSCi3L3plYzHpLOECsCEMw45+9phjlqolS31RCN6rgaJKBz8Cj9H9
1jMqErRmuYblXV+Zc4FMFNUdvyDUcyp54WdKLneBWQHaZQ+jdEZMeBMmKpmIXCSK6nvPuTM8
fciGLXpKhBEgpNzVcXGnHlHvuBXtVKmTsbyzaLf85/VFzeTxYvtkP+lNhwWavJXTOsIE45Ki
Dj8xLmHrKUROmyPMbskQbMaLF7o95nxKYFUAO0jpJwUWjq9iSlhUNoibVFoWp+Qc+JbvGqXJ
ZGlRR196y1xqPqEbKMn8OuYUVjsJgmlrGaiTN97hNB/37D+Hl/VWRu/7eLZ5Pa7eVvCf1XH5
+fPnv9xdA8XosgjmjDfr+vsTL4Ltea2KcGdONssDZgdRBEpMhYUHnesgq99xKPVMLZvQxcoX
IzDP0G0JzxBmM9XmdwSd/2Nkzd0TvqpcTHTVuAMBS6zKBHWfMA06IqvWvFpxLnb44V8dKcP9
Am0/ZG3+/A6ed7Fd+Z4lDBh3aIrGywKMlAQ7EPHe2ivp7QUA3EqH/AdEine/siRiPwSiwS0Z
XVQ/wLba1+4Z8CO182fEnm9/HzkpYbvEYyRjJVUPZRVkGRwkw+SHklzos4F6SNJJg5qQxLtv
ubA1t5xhmSjhSA5R1tqQGnSUiemYptHC7lBtHbOwGOMhMm+R4XsRnPCSSkpR5gMPmVUHL9Wf
Bte6Ch1EJtbWyGhcbpckzy7OeVXWYR1A7a4zp44giEEIBQkKjgQJw24Ahk1u2FWQ4vUdBOMZ
fKwuglqG1+KeomQefNXR7dWQ0zQqf5UnYpqPU4qtDNDP1Bjf7shXdG3rJp2O7hcLGXpeZWA2
kYYc5kAnodoPOwZC+6AL0451PUadNjq+HXGDdJqI1QAWyTjm4rWZU+7PKaEbwJimPF8yppY8
SXJ6PB3sHmEsv+1zJJr4zBNm6bxLKvdzztG+JGHRgd7D5A7ZwWIHeDPcgUstXBqlMa42jkoe
rEDeqroLgy0BGC2Pa50Xs6ubHR8Hc3wM0DEyShFSx7XspMs9xrRREkyAomBef0sCqVOg7xQk
rpQ0nTjsHIzXOElRlozPWInOpdKVx6kDh02R4dVagTyqY8C52zeJhj5t2KXm8aRjkt/F/PFS
dT6X8ee6PtFg2jX8eE82VsHr6HhbwxBDZ4TvMZPaoZ6K4NoxoeTryo7+8MqnekJKe1rWmlhN
ypiJ4qE8lwaxBztS5+qQV3rM/ZEuhCUAjF2e8qSeVPJA76VZVvIPtXOBUSVZM2Wp2JmMfCsi
C/4mMjT6/HIgz9Bw2CtQ+6RUVU1uiRLZVS4RhaMkRnuFlngDnH4YiVFuyCauya7Sm/4PrlWI
luwCAQA=

--wcydptwka6obxnng--
