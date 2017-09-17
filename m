From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [cifs:for-next 4/4] fs//cifs/smb2pdu.c:571:15: error: 'struct
 TCP_Server_Info' has no member named 'vol'
Date: Sun, 17 Sep 2017 10:16:35 -0500
Message-ID: <CAH2r5ms2f8cr4+JSKa_wTp+z7HheBeM-xMUi8bUFe-8nvJ2mog@mail.gmail.com>
References: <201709170529.dbKK1sNR%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201709170529.dbKK1sNR%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fixed - repushed to cifs-2.6.git for-next

On Sat, Sep 16, 2017 at 4:26 PM, kbuild test robot
<fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> head:   2ec9565c80e8669de38db875a9af6db6f6c418b7
> commit: 2ec9565c80e8669de38db875a9af6db6f6c418b7 [4/4] [SMB3] Add support for multidialect negotiate (SMB2.1 and later)
> config: xtensa-allyesconfig (attached as .config)
> compiler: xtensa-linux-gcc (GCC) 4.9.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 2ec9565c80e8669de38db875a9af6db6f6c418b7
>         # save the attached .config to linux build tree
>         make.cross ARCH=xtensa
>
> All errors (new ones prefixed by >>):
>
>    fs//cifs/smb2pdu.c: In function 'SMB2_negotiate':
>>> fs//cifs/smb2pdu.c:571:15: error: 'struct TCP_Server_Info' has no member named 'vol'
>        ses->server->vol->ops = &smb21_operations;
>                   ^
>
> vim +571 fs//cifs/smb2pdu.c
>
>    451
>    452  /*
>    453   *
>    454   *      SMB2 Worker functions follow:
>    455   *
>    456   *      The general structure of the worker functions is:
>    457   *      1) Call smb2_init (assembles SMB2 header)
>    458   *      2) Initialize SMB2 command specific fields in fixed length area of SMB
>    459   *      3) Call smb_sendrcv2 (sends request on socket and waits for response)
>    460   *      4) Decode SMB2 command specific fields in the fixed length area
>    461   *      5) Decode variable length data area (if any for this SMB2 command type)
>    462   *      6) Call free smb buffer
>    463   *      7) return
>    464   *
>    465   */
>    466
>    467  int
>    468  SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>    469  {
>    470          struct smb2_negotiate_req *req;
>    471          struct smb2_negotiate_rsp *rsp;
>    472          struct kvec iov[1];
>    473          struct kvec rsp_iov;
>    474          int rc = 0;
>    475          int resp_buftype;
>    476          struct TCP_Server_Info *server = ses->server;
>    477          int blob_offset, blob_length;
>    478          char *security_blob;
>    479          int flags = CIFS_NEG_OP;
>    480
>    481          cifs_dbg(FYI, "Negotiate protocol\n");
>    482
>    483          if (!server) {
>    484                  WARN(1, "%s: server is NULL!\n", __func__);
>    485                  return -EIO;
>    486          }
>    487
>    488          rc = small_smb2_init(SMB2_NEGOTIATE, NULL, (void **) &req);
>    489          if (rc)
>    490                  return rc;
>    491
>    492          req->hdr.sync_hdr.SessionId = 0;
>    493
>    494          if (strcmp(ses->server->vals->version_string,
>    495                  SMB3ANY_VERSION_STRING) == 0) {
>    496                  req->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
>    497                  req->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
>    498                  req->DialectCount = cpu_to_le16(2);
>    499                  inc_rfc1001_len(req, 4);
>    500          } else if (strcmp(ses->server->vals->version_string,
>    501                  SMB3DEFAULT_VERSION_STRING) == 0) {
>    502                  req->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
>    503                  req->Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
>    504                  req->Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
>    505                  req->DialectCount = cpu_to_le16(3);
>    506                  inc_rfc1001_len(req, 6);
>    507          } else {
>    508                  /* otherwise send specific dialect */
>    509                  req->Dialects[0] = cpu_to_le16(ses->server->vals->protocol_id);
>    510                  req->DialectCount = cpu_to_le16(1);
>    511                  inc_rfc1001_len(req, 2);
>    512          }
>    513
>    514          /* only one of SMB2 signing flags may be set in SMB2 request */
>    515          if (ses->sign)
>    516                  req->SecurityMode = cpu_to_le16(SMB2_NEGOTIATE_SIGNING_REQUIRED);
>    517          else if (global_secflags & CIFSSEC_MAY_SIGN)
>    518                  req->SecurityMode = cpu_to_le16(SMB2_NEGOTIATE_SIGNING_ENABLED);
>    519          else
>    520                  req->SecurityMode = 0;
>    521
>    522          req->Capabilities = cpu_to_le32(ses->server->vals->req_capabilities);
>    523
>    524          /* ClientGUID must be zero for SMB2.02 dialect */
>    525          if (ses->server->vals->protocol_id == SMB20_PROT_ID)
>    526                  memset(req->ClientGUID, 0, SMB2_CLIENT_GUID_SIZE);
>    527          else {
>    528                  memcpy(req->ClientGUID, server->client_guid,
>    529                          SMB2_CLIENT_GUID_SIZE);
>    530                  if (ses->server->vals->protocol_id == SMB311_PROT_ID)
>    531                          assemble_neg_contexts(req);
>    532          }
>    533          iov[0].iov_base = (char *)req;
>    534          /* 4 for rfc1002 length field */
>    535          iov[0].iov_len = get_rfc1002_length(req) + 4;
>    536
>    537          rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
>    538          cifs_small_buf_release(req);
>    539          rsp = (struct smb2_negotiate_rsp *)rsp_iov.iov_base;
>    540          /*
>    541           * No tcon so can't do
>    542           * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
>    543           */
>    544          if (rc == -EOPNOTSUPP) {
>    545                  cifs_dbg(VFS, "Dialect not supported by server. Consider "
>    546                          "specifying vers=1.0 or vers=2 on mount for accessing"
>    547                          " older servers\n");
>    548                  goto neg_exit;
>    549          } else if (rc != 0)
>    550                  goto neg_exit;
>    551
>    552          if (strcmp(ses->server->vals->version_string,
>    553                          SMB3ANY_VERSION_STRING) == 0) {
>    554                  if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
>    555                          cifs_dbg(VFS,
>    556                                  "SMB2 dialect returned but not requested\n");
>    557                          return -EIO;
>    558                  } else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
>    559                          cifs_dbg(VFS,
>    560                                  "SMB2.1 dialect returned but not requested\n");
>    561                          return -EIO;
>    562                  }
>    563          } else if (strcmp(ses->server->vals->version_string,
>    564                          SMB3DEFAULT_VERSION_STRING) == 0) {
>    565                  if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
>    566                          cifs_dbg(VFS,
>    567                                  "SMB2 dialect returned but not requested\n");
>    568                          return -EIO;
>    569                  } else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
>    570                          /* ops set to 3.0 by default for default so udpate */
>  > 571                          ses->server->vol->ops = &smb21_operations;
>    572                  }
>    573          }
>    574          /* BB add check that individually requested dialects match returned */
>    575
>    576          cifs_dbg(FYI, "mode 0x%x\n", rsp->SecurityMode);
>    577
>    578          if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
>    579                  cifs_dbg(FYI, "negotiated smb2.0 dialect\n");
>    580          } else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID))
>    581                  cifs_dbg(FYI, "negotiated smb2.1 dialect\n");
>    582          else if (rsp->DialectRevision == cpu_to_le16(SMB30_PROT_ID))
>    583                  cifs_dbg(FYI, "negotiated smb3.0 dialect\n");
>    584          else if (rsp->DialectRevision == cpu_to_le16(SMB302_PROT_ID))
>    585                  cifs_dbg(FYI, "negotiated smb3.02 dialect\n");
>    586  #ifdef CONFIG_CIFS_SMB311
>    587          else if (rsp->DialectRevision == cpu_to_le16(SMB311_PROT_ID))
>    588                  cifs_dbg(FYI, "negotiated smb3.1.1 dialect\n");
>    589  #endif /* SMB311 */
>    590          else {
>    591                  cifs_dbg(VFS, "Illegal dialect returned by server 0x%x\n",
>    592                           le16_to_cpu(rsp->DialectRevision));
>    593                  rc = -EIO;
>    594                  goto neg_exit;
>    595          }
>    596          server->dialect = le16_to_cpu(rsp->DialectRevision);
>    597
>    598          /* BB: add check that dialect was valid given dialect(s) we asked for */
>    599
>    600          /* SMB2 only has an extended negflavor */
>    601          server->negflavor = CIFS_NEGFLAVOR_EXTENDED;
>    602          /* set it to the maximum buffer size value we can send with 1 credit */
>    603          server->maxBuf = min_t(unsigned int, le32_to_cpu(rsp->MaxTransactSize),
>    604                                 SMB2_MAX_BUFFER_SIZE);
>    605          server->max_read = le32_to_cpu(rsp->MaxReadSize);
>    606          server->max_write = le32_to_cpu(rsp->MaxWriteSize);
>    607          /* BB Do we need to validate the SecurityMode? */
>    608          server->sec_mode = le16_to_cpu(rsp->SecurityMode);
>    609          server->capabilities = le32_to_cpu(rsp->Capabilities);
>    610          /* Internal types */
>    611          server->capabilities |= SMB2_NT_FIND | SMB2_LARGE_FILES;
>    612
>    613          security_blob = smb2_get_data_area_len(&blob_offset, &blob_length,
>    614                                                 &rsp->hdr);
>    615          /*
>    616           * See MS-SMB2 section 2.2.4: if no blob, client picks default which
>    617           * for us will be
>    618           *      ses->sectype = RawNTLMSSP;
>    619           * but for time being this is our only auth choice so doesn't matter.
>    620           * We just found a server which sets blob length to zero expecting raw.
>    621           */
>    622          if (blob_length == 0) {
>    623                  cifs_dbg(FYI, "missing security blob on negprot\n");
>    624                  server->sec_ntlmssp = true;
>    625          }
>    626
>    627          rc = cifs_enable_signing(server, ses->sign);
>    628          if (rc)
>    629                  goto neg_exit;
>    630          if (blob_length) {
>    631                  rc = decode_negTokenInit(security_blob, blob_length, server);
>    632                  if (rc == 1)
>    633                          rc = 0;
>    634                  else if (rc == 0)
>    635                          rc = -EIO;
>    636          }
>    637  neg_exit:
>    638          free_rsp_buf(resp_buftype, rsp);
>    639          return rc;
>    640  }
>    641
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation



-- 
Thanks,

Steve
