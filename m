From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Purpose of GLOBAL_EXTERN macro
Date: Tue, 11 Oct 2011 15:10:09 +0530
Message-ID: <4E940EF9.7030603@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I bumped into the GLOBAL_EXTERN macro in the cifs code. I'm not sure I
understand the purpose of this. Can someone explain why we need this
instead of simply using "extern"?


Thanks
Suresh
