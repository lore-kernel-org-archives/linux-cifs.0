From: Jeremy Allison <jra@samba.org>
Subject: Re: SMB3 Session Setup
Date: Tue, 2 Oct 2012 21:49:28 -0700
Message-ID: <20121003044928.GD14358@jeremy-HP>
References: <CAH2r5msryv+HwGes5wy-3wugDGv+FbUk01M3HDHziVfgzCZ=DA@mail.gmail.com>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msryv+HwGes5wy-3wugDGv+FbUk01M3HDHziVfgzCZ=DA@mail.gmail.com>
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

On Tue, Oct 02, 2012 at 11:39:46PM -0500, Steve French wrote:
> I noticed some odd differences between Samba 4 (current master) and
> Windows 8 in SMB3 session setup handling (both fail for different
> reasons at the moment from the linux cifs client, while smb2.1 works).
> 
> negotiate protocol to both (Samba and Windows 8) look similar.  In
> this case I am requesting only one dialect smb3
> session setup phase 1 (raw ntlmssp) looks similar.
> three cases for session setup phase two
> 1) if bad password:  then I get STATUS_LOGON_FAILURE as expected
> 2) if good password (which worked with smb2.1) then to Samba server I
> get Samba sending back a signed response (success), even though I
> didn't ask for signing

I think you're running into:

[Bug 9222] New: smbd ignores the "server signing = no" setting for SMB2.

https://bugzilla.samba.org/show_bug.cgi?id=9222

which I just fixed in master. Re-checkout the git
tree and try again.

> 3) if good password (which worked with smb2.1) then to Windows 8
> server I get Windows 8 sending back an error response
> "STATUS_USER_SESSION_DELETED"
> Any idea what that error means?

Crypto stuff has changed (again :-) ?

Jeremy.
