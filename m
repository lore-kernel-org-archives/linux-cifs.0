From: Andrew Bartlett <abartlet@samba.org>
Subject: Re: [PATCH] cifs: ignore everything in SPNEGO blob after mechTypes
Date: Mon, 18 Mar 2013 08:14:14 +1100
Message-ID: <1363554854.27367.8.camel@jesse>
References: <1363009939-2264-1-git-send-email-jlayton@redhat.com>
	<CAH2r5mtcACcO5YfVzRptJO2ob=SYEgVyTtHBUc7XZS_n57XjAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, jason@jacknife2.dns2go.com,
	samba-technical <samba-technical@lists.samba.org>,
	Jeff Layton <jlayton@redhat.com>, elliot.li.tech@gmail.com
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAH2r5mtcACcO5YfVzRptJO2ob=SYEgVyTtHBUc7XZS_n57XjAw@mail.gmail.com>
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

On Sun, 2013-03-17 at 09:37 -0500, Steve French wrote:
> The existing code is trying to dump the "principal" from the
> mechListMic (presumably for debugging) in the SMB negotiate response.
> In the trace I looked at Samba server set it to "NONE"  - is there a
> case where we would ever need that?

No, the "principal" should never be used, and isn't even useful for
debugging as you should just never use it.  It can be set to strange and
invalid values such as NONE and rfc....should_ignore

Andrew Bartlett

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
