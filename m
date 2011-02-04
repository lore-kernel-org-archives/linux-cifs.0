From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs: don't always drop malformed replies on the floor
Date: Thu, 3 Feb 2011 23:01:45 -0600
Message-ID: <AANLkTim4p3fT4Sa6aoqqr1sBAFv8a6_7RLYOi2j2fP8s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looking at this comment in the patch:

+		 * FIXME: why 48 bytes?
+		 */
+		length = checkSMB(smb_buffer, smb_buffer->Mid, total_read);
+		if (length != 0)
 			cifs_dump_mem("Bad SMB: ", smb_buffer,
 					total_read < 48 ? total_read : 48);


got me thinking, if you prefer a longer length that is fine.   To
avoid huge log entries, while still dumping the most useful info, the
original length dumped was limited.  48 bytes was chosen because it
printed 3 lines of 16 to log and thus would include the most important
parts of the SMB (past wct).  It is large enough to fit a close
request and response, although about 10 bytes to small for getting all
of a SMB ReadX request.   It would probably be fine to make that 64
bytes if you prefer.   If we made it smaller (e.g. 32 instead of 48)
IIRC we wouldn't get wct.
-- 
Thanks,

Steve
