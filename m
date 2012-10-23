From: steve <steve@steve-ss.com>
Subject: Re: CIFS: Deprecating NFS mounting syntax in mount.cifs
Date: Tue, 23 Oct 2012 18:47:37 +0200
Message-ID: <5086CA29.8030305@steve-ss.com>
References: <1350583669-12118-1-git-send-email-scott.lovenberg@gmail.com>
	<5086BE25.8080102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: samba@lists.samba.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, jlayton@redhat.com, smfrench@gmail.com
To: Scott Lovenberg <scott.lovenberg@gmail.com>
Return-path: <samba-bounces@lists.samba.org>
In-Reply-To: <5086BE25.8080102@gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba>,
	<mailto:samba-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba>
List-Post: <mailto:samba@lists.samba.org>
List-Help: <mailto:samba-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba>,
	<mailto:samba-request@lists.samba.org?subject=subscribe>
Sender: samba-bounces@lists.samba.org
Errors-To: samba-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On 10/23/2012 05:56 PM, Scott Lovenberg wrote:
> On 10/18/2012 2:07 PM, scott.lovenberg@gmail.com wrote:
> no one has objected (or really said anything).  Can we merge this patch?
> --
Hi
I'm just trying to represent users. Can we take this to user level by 
giving an example of what will work and what will not work after the patch?

For example, the Linux automounter.

Currently, we have this map:
* -fstype=cifs,rw,sec=krb5 ://myserver/myshare/&

Are you talking about the difference between that and this:
* -fstype=cifs,rw,sec=krb5 myserver:/myshare/&

Question: will I need to change anything due to this patch?

Cheers,
Steve

-- 
To unsubscribe from this list go to the following URL and read the
instructions:  https://lists.samba.org/mailman/options/samba
