From: Steve French <smfrench@gmail.com>
Subject: Credits for session setup
Date: Thu, 4 Oct 2012 14:26:26 -0500
Message-ID: <CAH2r5mu0jFiXwvVZidJ_XTyXK=AvNVKZEby=pjmipi86VJndvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: samba-technical <samba-technical@lists.samba.org>
To: linux-cifs@vger.kernel.org
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

Samba server only grants one credit on SMB2 session setup (ntlmssp
phase one) - we need to change linux cifs client's "change conf"
routine to not disable oplocks and echo requests (we only exempt
negotiate protocol response returning one credit).

-- 
Thanks,

Steve
