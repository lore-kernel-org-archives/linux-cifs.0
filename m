From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: smatch stuff: dereferencing first then checking in SendReceive()
Date: Sun, 20 Mar 2011 02:28:58 +0300
Message-ID: <20110319232857.GA28096@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Smatch complains about this, but I don't know if it's a bug or not.

fs/cifs/transport.c +791 SendReceive(106)
	warn: variable dereferenced before check 'midQ->resp_buf'

   780          receive_len = be32_to_cpu(midQ->resp_buf->smb_buf_length);
                                          ^^^^^^^^^^^^^^^^
	dereference
   781
   782          if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
   783                  cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
   784                          receive_len, xid);
   785                  rc = -EIO;
   786                  goto out;
   787          }
   788
   789          /* rcvd frame is ok */
   790
   791          if (midQ->resp_buf && out_buf
                    ^^^^^^^^^^^^^^
	checking for null

   792              && (midQ->midState == MID_RESPONSE_RECEIVED)) {
   793                  out_buf->smb_buf_length = cpu_to_be32(receive_len);

regards,
dan carpenter
