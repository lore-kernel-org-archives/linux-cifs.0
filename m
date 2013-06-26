From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: [CIFS] SMB2 FSCTL and IOCTL worker function
Date: Wed, 26 Jun 2013 23:27:28 +0300
Message-ID: <20130626202728.GA23889@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Steve French,

This is a semi-automatic email about new static checker warnings.

The patch 73ff09308dc7: "[CIFS] SMB2 FSCTL and IOCTL worker function" 
from Jun 25, 2013, leads to the following Smatch complaint:

fs/cifs/smb2pdu.c:1078 SMB2_ioctl()
	 warn: variable dereferenced before check 'tcon' (see line 1015)

fs/cifs/smb2pdu.c
  1014		struct TCP_Server_Info *server;
  1015		struct cifs_ses *ses = tcon->ses;
                                       ^^^^^^^^^
New dereference.

  1016		struct kvec iov[2];
  1017		int resp_buftype;
  1018		int num_iovecs;
  1019		int rc = 0;
  1020	
  1021		cifs_dbg(FYI, "SMB2 IOCTL\n");
  1022	
  1023		/* zero out returned data len, in case of error */
  1024		if (plen)
  1025			*plen = 0;
  1026	
  1027		if (ses && (ses->server))
  1028			server = ses->server;
  1029		else
  1030			return -EIO;
  1031	
  1032		rc = small_smb2_init(SMB2_IOCTL, tcon, (void **) &req);
  1033		if (rc)
  1034			return rc;
  1035	
  1036		req->CtlCode = cpu_to_le32(opcode);
  1037		req->PersistentFileId = persistent_fid;
  1038		req->VolatileFileId = volatile_fid;
  1039	
  1040		if (indatalen) {
  1041			req->InputCount = cpu_to_le32(indatalen);
  1042			/* do not set InputOffset if no input data */
  1043			req->InputOffset =
  1044			       cpu_to_le32(offsetof(struct smb2_ioctl_req, Buffer) - 4);
  1045			iov[1].iov_base = in_data;
  1046			iov[1].iov_len = indatalen;
  1047			num_iovecs = 2;
  1048		} else
  1049			num_iovecs = 1;
  1050	
  1051		req->OutputOffset = 0;
  1052		req->OutputCount = 0; /* MBZ */
  1053	
  1054		/* 
  1055		 * Could increase MaxOutputResponse, but that would require more
  1056		 * than one credit. Windows typically sets this smaller, but for some
  1057		 * ioctls it may be useful to allow server to send more. No point
  1058		 * limiting what the server can send as long as fits in one credit
  1059		 */
  1060		req->MaxOutputResponse = cpu_to_le32(0xFF00); /* < 64K uses 1 credit */
  1061	
  1062		if (is_fsctl)
  1063			req->Flags = cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL);
  1064		else
  1065			req->Flags = 0;
  1066	
  1067		iov[0].iov_base = (char *)req;
  1068		/* 4 for rfc1002 length field */
  1069		iov[0].iov_len = get_rfc1002_length(req) + 4;
  1070	
  1071		if (indatalen)
  1072			inc_rfc1001_len(req, indatalen);
  1073	
  1074		rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
  1075		rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;
  1076	
  1077		if (rc != 0) {
  1078			if (tcon)
                            ^^^^
New check.

  1079				cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
  1080			goto ioctl_exit;

regards,
dan carpenter
