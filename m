From: Steve French <smfrench@gmail.com>
Subject: SMB3 Session Setup
Date: Tue, 2 Oct 2012 23:39:46 -0500
Message-ID: <CAH2r5msryv+HwGes5wy-3wugDGv+FbUk01M3HDHziVfgzCZ=DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs@vger.kernel.org
To: samba-technical@lists.samba.org
Return-path: <samba-technical-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

I noticed some odd differences between Samba 4 (current master) and
Windows 8 in SMB3 session setup handling (both fail for different
reasons at the moment from the linux cifs client, while smb2.1 works).

negotiate protocol to both (Samba and Windows 8) look similar.  In
this case I am requesting only one dialect smb3
session setup phase 1 (raw ntlmssp) looks similar.
three cases for session setup phase two
1) if bad password:  then I get STATUS_LOGON_FAILURE as expected
2) if good password (which worked with smb2.1) then to Samba server I
get Samba sending back a signed response (success), even though I
didn't ask for signing
3) if good password (which worked with smb2.1) then to Windows 8
server I get Windows 8 sending back an error response
"STATUS_USER_SESSION_DELETED"
Any idea what that error means?





-- 
Thanks,

Steve
