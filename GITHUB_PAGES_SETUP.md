# GitHub Pages Setup for Privacy Policy

## 🚀 Quick Setup (2 minutes)

### Step 1: Enable GitHub Pages
1. Go to: https://github.com/ronospace/Flow-iQ/settings/pages
2. Under "Source", select: **Deploy from a branch**
3. Under "Branch", select: **main** and **/ (root)**
4. Click **Save**

### Step 2: Wait for Deployment
- GitHub will automatically deploy your site
- Takes 1-5 minutes
- You'll see a green checkmark when ready

### Step 3: Your Privacy Policy URL
Once deployed, your privacy policy will be available at:

```
https://ronospace.github.io/Flow-iQ/privacy-policy.html
```

## 📝 Use This URL In:

### App Store Connect
```
Privacy Policy URL: https://ronospace.github.io/Flow-iQ/privacy-policy.html
```

### Google Play Console
```
Privacy Policy URL: https://ronospace.github.io/Flow-iQ/privacy-policy.html
```

---

## ✅ Verification

To verify it's working:
1. Visit: https://ronospace.github.io/Flow-iQ/privacy-policy.html
2. You should see your Flow iQ Privacy Policy
3. If not ready yet, wait a few more minutes

---

## 🔄 Alternative: Custom Domain (Optional)

If you have your own domain (e.g., flowiq.health):

1. Add a CNAME file to your repo:
   ```bash
   echo "flowiq.health" > CNAME
   git add CNAME
   git commit -m "Add custom domain"
   git push
   ```

2. Configure DNS:
   - Add CNAME record: `www` → `ronospace.github.io`
   - Add A records for apex domain

3. Privacy Policy URL becomes:
   ```
   https://flowiq.health/privacy-policy.html
   ```

---

## 📞 Need Help?

If GitHub Pages doesn't work:
- Check repository settings → Pages
- Ensure repository is public
- Verify branch is set to 'main'
- Check Actions tab for deployment status

**Troubleshooting URL:**
https://github.com/ronospace/Flow-iQ/actions
